//
//  DetailViewController.swift
//  AlbumArt
//
//  Created by Vincent Yu on 2/24/19.
//  Copyright © 2019 Vincent Yu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: Properties
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var album: Album?
    var isFavorite: Bool?
    var delegate: FavoriteDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let album = album, let isFavorite = isFavorite else { return }
        // Do any additional setup after loading the view.
        albumLabel.text = album.collectionName
        artistLabel.text = album.artistName
        if isFavorite { favoriteButton.setImage(UIImage(named: "Filled Heart"), for: .normal) }
    }
    
    // MARK: Actions
    @IBAction func tap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickFavoriteButton(_ sender: Any) {
        guard let album = self.album, let isFavorite = self.isFavorite else { return }
        if isFavorite {
            favoriteButton.setImage(UIImage(named: "Empty Heart"), for: .normal)
            delegate?.removeFavorite(album)
        }
        else {
            favoriteButton.setImage(UIImage(named: "Filled Heart"), for: .normal)
            delegate?.addFavorite(album)
        }
        self.isFavorite = !self.isFavorite!
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
