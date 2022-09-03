//
//  PlayList.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/08/31.
//

import Foundation

final class PlayLists {
    static var shared = PlayLists()
    var playListIds: [String:[Int]] = {
        UserDefaults.loadPlayList()
    }() ?? [String:[Int]]()
    private init() {}
    
    func addPlayListIds(playListTitle: String, songIds: [Int]) {
        playListIds[playListTitle] = []
        for songId in songIds {
            playListIds[playListTitle]?.append(songId)
        }
        UserDefaults.savePlayList()
    }

    func changePlayListTitle(playListTitle: String, newPlayListTitle: String) {
        guard let changePlayListIds = playListIds[playListTitle] else {
            Logger.log(message: "プレイリスト名の変更に失敗しました")
            return
        }
        playListIds.updateValue(changePlayListIds, forKey: newPlayListTitle)
        playListIds.removeValue(forKey: playListTitle)
        UserDefaults.savePlayList()
    }

    func removePlayList(playListTitle: String) {
        playListIds.removeValue(forKey: playListTitle)
        UserDefaults.savePlayList()
    }
    
    func removePlayListIds(playListTitle: String, songIds: [Int]) {
        for songId in songIds {
            playListIds[playListTitle]?.removeAll(where: {$0 == songId})
        }
        UserDefaults.savePlayList()
    }
}
