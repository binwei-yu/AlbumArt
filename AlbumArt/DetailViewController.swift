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
    
    var albumName: String?
    var artistName: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        albumLabel.text = albumName
        artistLabel.text = artistName
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
