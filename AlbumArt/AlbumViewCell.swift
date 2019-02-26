//
//  AlbumViewCell.swift
//  AlbumArt
//
//  Created by Vincent Yu on 2/25/19.
//  Copyright © 2019 Vincent Yu. All rights reserved.
//

import UIKit

class AlbumViewCell: UICollectionViewCell {
    // MARK: Properties
    @IBOutlet weak var albumCoverImage: UIImageView!
    @IBOutlet weak var favoriteImage: UIImageView!
    
    var albumId: Int?
}
