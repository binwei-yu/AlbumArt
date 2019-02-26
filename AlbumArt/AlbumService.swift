//
//  MusicService.swift
//  AlbumArt
//
//  Created by Vincent Yu on 2/25/19.
//  Copyright © 2019 Vincent Yu. All rights reserved.
//

import Foundation
import UIKit

struct Album: Codable {
    let wrapperType: String
    let collectionType: String
    let artistId: Int
    let collectionId: Int
    let amgArtistId: Int?
    let artistName: String
    let collectionName: String
    let collectionCensoredName: String
    let artistViewUrl: String?
    let collectionViewUrl: String
    let artworkUrl60: String
    let artworkUrl100: String
    let collectionPrice: Double?
    let collectionExplicitness: String
    let contentAdvisoryRating: String?
    let trackCount: Int
    let copyright: String?
    let country: String
    let currency: String
    let releaseDate: String
    let primaryGenreName: String
}

struct AlbumResult: Codable {
    let resultCount: Int
    let results: [Album]
}

class AlbumService {
    // MARK: Properties
    private let urlString = "https://itunes.apple.com/search?country=US&media=music&entity=album&limit=100&term=japanese"
    
    // MARK: Function
    public func search(completion: @escaping ([Album]?, Error?) -> ()) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(nil, error) }
                return
            }
            do {
                let decoder = JSONDecoder()
                let albumResult = try decoder.decode(AlbumResult.self, from: data)
                DispatchQueue.main.async { completion(albumResult.results, nil) }
            } catch(let error) {
                DispatchQueue.main.async { completion(nil, error) }
            }
        }
        task.resume()
    }
    
    public func fetchImage(for searchURL: String, completion: @escaping (UIImage?, Error?) -> ()) {
        guard let url = URL(string: searchURL) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(nil, error) }
                return
            }
            if let image = UIImage(data: data) {
                DispatchQueue.main.async { completion(image, nil) }
            } else {
                DispatchQueue.main.async { completion(nil, error) }
            }
        }
        task.resume()
    }
}
