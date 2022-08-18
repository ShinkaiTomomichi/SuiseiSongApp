//
//  History.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/08/10.
//

import Foundation

final class Histories {
    static var shared = Histories()
    let maxSize = 100
    var historyIds: [Int] = {
        UserDefaults.loadHistory()
    }() ?? []
    private init() {}
    
    func addHistory(songId: Int) {
        // 同じ動画を連続で履歴に追加しないようにする
        // TODO: ただし挙動のバグっぽいものもあるので後に直す
        guard historyIds.last != songId else {
            return
        }
        historyIds.append(songId)
        if historyIds.count > maxSize {
            rotateHistory()
        }
        UserDefaults.saveHistory()
    }
    
    func rotateHistory() {
        let removeSize = historyIds.count - maxSize
        historyIds.removeSubrange(0...removeSize)
    }
}
