//
//  Favorites.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/08/10.
//

import Foundation

final class Favorites {
    static var shared = Favorites()
    // Setの方が望ましいが、順序列を維持するためにArrayにする
    var favoriteIds: [Int] = {
        UserDefaults.loadFavorite()
    }() ?? []
    private init() {}
    
    func addFavorite(songId: Int) {
        if !favoriteIds.contains(songId) {
            favoriteIds.append(songId)
        }
        UserDefaults.saveFavorite()
    }
    
    func removeFavorite(songId: Int) {
        favoriteIds.removeAll(where: {$0 == songId})
        UserDefaults.saveFavorite()
    }
}
