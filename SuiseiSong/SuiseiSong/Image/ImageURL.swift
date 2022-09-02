//
//  ImageURL.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/09/01.
//

import Foundation

struct ImageURL: Codable {
    var name: String
    var url: String
    
    static func getUrl(byName: String, imageURLs: [ImageURL]) -> String? {
        let imageURLs_ = imageURLs.filter({ $0.name == byName })
        if imageURLs_.count > 0 {
            return imageURLs_[0].url
        } else {
            return nil
        }
    }
}
