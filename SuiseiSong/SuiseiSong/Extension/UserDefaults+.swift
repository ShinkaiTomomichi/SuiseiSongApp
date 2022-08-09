//
//  UserDefaults.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/08/05.
//

import Foundation

extension UserDefaults {
    // デバッグ用の修正時刻の保存
    static func saveModifiedTime(id: Int, startTime: Int, endTime: Int) {
        let idString = "modified:"+String(id)
        let value = String(startTime) + "&" + String(endTime)
        UserDefaults.standard.set(value, forKey: idString)
    }
    
    static func printModifiled() {
        UserDefaults.standard.dictionaryRepresentation().forEach {
            let key = $0.key
            if key.contains("modified:") {
                let value = $0.value as! String
                Logger.log(message: "key:\(key), value:\(value)")
            }
        }
    }
    
    // 履歴の保存
    static func keyHistory() -> String {
        return "history"
    }
    
    static func saveHistory() {
        let favorite = Favorites.shared.favoriteIds
        UserDefaults.standard.set(favorite, forKey: keyFavorite())
    }
    
    static func loadHistory() -> [String]? {
        guard let history = UserDefaults.standard.stringArray(forKey: keyHistory()) else {
            return nil
        }
        return history
    }
    
    // お気に入りの保存
    static func keyFavorite() -> String {
        return "Favorite"
    }
    
    static func saveFavorite() {
        let favorite = Favorites.shared.favoriteIds
        UserDefaults.standard.set(Array(favorite), forKey: keyFavorite())
    }
    
    static func loadFavorite() -> Set<String>? {
        guard let favorite = UserDefaults.standard.stringArray(forKey: keyFavorite()) else {
            return nil
        }
        return Set(favorite)
    }
    
    static func removeAll() {
        UserDefaults.standard.dictionaryRepresentation().forEach {
            UserDefaults.standard.removeObject(forKey: $0.key)
        }
    }
}
