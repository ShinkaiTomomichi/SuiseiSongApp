//
//  UserDefaults.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/08/05.
//

import Foundation

extension UserDefaults {
    // プレイリストの保存
    static func keyPlayList() -> String {
        return "playlist"
    }
    
    // 文字列から変換する処理を入れる
    static func savePlayList() {
        let playListIds = PlayLists.shared.playListIds
        Logger.log(message: playListIds)
        var playListIds_:[String:String] = [:]
        for (key, value) in playListIds {
            let str = value.toString()
            playListIds_.updateValue(str, forKey: key)
        }
        UserDefaults.standard.set(playListIds_, forKey: keyPlayList())
    }
    
    static func loadPlayList() -> [String: [Int]]? {
        guard let playListIds = UserDefaults.standard.dictionary(forKey: keyPlayList()) else {
            return nil
        }
        var playListIds_:[String:[Int]] = [:]
        for (key, value) in playListIds {
            let str = value as! String
            let intList = str.components(separatedBy: ",").compactMap { Int($0) }
            playListIds_.updateValue(intList, forKey: key)
        }
        
        return playListIds_
    }
    
    static func removePlayList() {
        UserDefaults.standard.removeObject(forKey: keyPlayList())
    }
    
    // 履歴の保存
    static func keyHistory() -> String {
        return "history"
    }
    
    static func saveHistory() {
        let histories = Histories.shared.historyIds
        UserDefaults.standard.set(histories, forKey: keyHistory())
    }
    
    static func loadHistory() -> [Int]? {
        guard let history = UserDefaults.standard.array(forKey: keyHistory()) else {
            return nil
        }
        return history.compactMap { $0 as? Int }
    }
    
    static func removeHistory() {
        UserDefaults.standard.removeObject(forKey: keyHistory())
    }
    
    // お気に入りの保存
    static func keyFavorite() -> String {
        return "Favorite"
    }
    
    static func saveFavorite() {
        let favorite = Favorites.shared.favoriteIds
        UserDefaults.standard.set(Array(favorite), forKey: keyFavorite())
    }
    
    static func loadFavorite() -> [Int]? {
        guard let favorite = UserDefaults.standard.array(forKey: keyFavorite()) else {
            return nil
        }
        return favorite.compactMap { $0 as? Int }
    }
    
    static func removeFavorite() {
        UserDefaults.standard.removeObject(forKey: keyFavorite())
    }
    
    static func removeAll() {
        UserDefaults.standard.dictionaryRepresentation().forEach {
            UserDefaults.standard.removeObject(forKey: $0.key)
        }
    }
}
