//
//  MasterViewController.swift
//  AlbumArt
//
//  Created by Vincent Yu on 2/25/19.
//  Copyright © 2019 Vincent Yu. All rights reserved.
//

import UIKit

private let reuseIdentifier = "AlbumCell"

class MasterViewController: UICollectionViewController {

    // MARK: Properties
    private let albumService = AlbumService()
    public var albums: [Album] = []
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
        return albums.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AlbumViewCell
        
        // Configure the cell
        let album = albums[indexPath.row]
        albumService.fetchImage(for: album.artworkUrl100) { image, error in
            if image != nil {
                cell.albumCoverImage.image = image
            }
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dest = segue.destination as? DetailViewController else { return }
        guard let src = sender as? AlbumViewCell else { return }
        guard let index = collectionView.indexPath(for: src)?.row else { return }
        
        let album = albums[index]
        dest.albumName = album.collectionName
        dest.artistName = album.artistName
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
