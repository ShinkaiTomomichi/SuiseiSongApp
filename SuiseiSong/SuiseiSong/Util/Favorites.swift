//
//  Favorites.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/08/10.
//

import Foundation

final class Favorites {
    static var shared = Favorites()
    var favoriteIds: Set<Int> = {
        UserDefaults.loadFavorite()
    }() ?? []
    private init() {}
    
    func addFavorite(songId: Int) {
        favoriteIds.insert(songId)
        UserDefaults.saveFavorite()
    }
    
    func removeFavorite(songId: Int) {
        favoriteIds.remove(songId)
        UserDefaults.saveFavorite()
    }
}
