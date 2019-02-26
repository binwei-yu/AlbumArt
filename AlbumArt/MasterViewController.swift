//
//  MasterViewController.swift
//  AlbumArt
//
//  Created by Vincent Yu on 2/25/19.
//  Copyright © 2019 Vincent Yu. All rights reserved.
//

import UIKit

private let reuseIdentifier = "AlbumCell"

protocol FavoriteDelegate: class {
    func addFavorite(_ album: Album)
    func removeFavorite(_ album: Album)
}

class MasterViewController: UICollectionViewController, FavoriteDelegate {
    
    // MARK: Properties
    private let albumService = AlbumService()
    private var currentView = 0
    public var albums: [Album] = []
    public var favorites: [Album] = []
    public var favoritesSet: Set<Int> = []
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    @IBAction func toggle(_ sender: UISegmentedControl) {
        self.currentView = sender.selectedSegmentIndex
        self.collectionView.reloadData()
    }
    
    func addFavorite(_ album: Album) {
        self.favorites.append(album)
        self.favoritesSet.insert(album.collectionId)
        
        // All
        if self.currentView == 0 {
            // Show favorite icon
            hideFavoriteImage(of: album, isHidden: false)
        }
        // Favorite
        else {
            let insertIndexPath = IndexPath(row: self.collectionView.visibleCells.count, section: 0)
            self.collectionView.insertItems(at: [insertIndexPath])
        }
    }
    
    func removeFavorite(_ album: Album) {
        var index: Int = 0
        for (i, item) in favorites.enumerated() {
            if item.collectionId == album.collectionId {
                favorites.remove(at: i)
                index = i
                break
            }
        }
        self.favoritesSet.remove(album.collectionId)
        
        // All
        if self.currentView == 0 {
            // Hide favorite icon
            hideFavoriteImage(of: album, isHidden: true)
        }
        else {
            let removeIndexPath = IndexPath(row: index, section: 0)
            self.collectionView.deleteItems(at: [removeIndexPath])
        }
    }
    
    private func hideFavoriteImage(of album: Album, isHidden: Bool) {
        for cell in self.collectionView.visibleCells {
            let cell = cell as! AlbumViewCell
            if cell.albumId == album.collectionId {
                cell.favoriteImage.isHidden = isHidden
                return
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Animate activity indicator
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()

        // Fetch data
        albumService.search() { data, error in
            guard let data = data, error == nil else {
                print(error ?? "Unknown error")
                let alertController = UIAlertController(title: "Error", message: "Network failed", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                    alertController.dismiss(animated: true, completion: nil)
                }
                
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            self.albums = data
            
            // Hide activity indicator
            self.activityIndicator.isHidden = true
            
            // Reload data
            self.collectionView.reloadData()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if self.currentView == 0 {
            return albums.count
        }
        else {
            return favorites.count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AlbumViewCell
        
        // Configure the cell
        if self.currentView == 0 {
            let album = albums[indexPath.row]
            albumService.fetchImage(for: album.artworkUrl100) { image, error in
                cell.albumCoverImage.image = image ?? UIImage(named: "Unknown Cover")
            }
            if favoritesSet.contains(album.collectionId) {
                cell.favoriteImage.isHidden = false
            }
            else {
                cell.favoriteImage.isHidden = true
            }
            cell.albumId = album.collectionId
        }
        else {
            let album = self.favorites[indexPath.row]
            albumService.fetchImage(for: album.artworkUrl100) { image, error in
                if image != nil {
                    cell.albumCoverImage.image = image
                }
            }
            cell.albumId = album.collectionId
            // Show favorite icon
            cell.favoriteImage.isHidden = false
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dest = segue.destination as? DetailViewController else { return }
        guard let src = sender as? AlbumViewCell else { return }
        guard let index = collectionView.indexPath(for: src)?.row else { return }
        
        if self.currentView == 0 {
            if self.favoritesSet.contains(albums[index].collectionId) {
                dest.isFavorite = true
            }
            else {
                dest.isFavorite = false
            }
            dest.album = albums[index]
        }
        else {
            dest.isFavorite = true
            dest.album = favorites[index]
        }
        dest.delegate = self
    }
}
