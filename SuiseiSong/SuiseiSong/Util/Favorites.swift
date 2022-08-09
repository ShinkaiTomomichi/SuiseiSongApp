//
//  Favorites.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/08/10.
//

import Foundation

final class Favorites {
    static var shared = Favorites()
    var favoriteIds: Set<String> = {
        UserDefaults.loadFavorite()
    }() ?? []
    private init() {}
    
    func addFavorite(videoId: String) {
        favoriteIds.insert(videoId)
        NotificationCenter.default.post(name: .didChangedFavorite, object: nil)
    }
    
    func removeFavorite(videoId: String) {
        favoriteIds.remove(videoId)
        NotificationCenter.default.post(name: .didChangedFavorite, object: nil)
    }
}
