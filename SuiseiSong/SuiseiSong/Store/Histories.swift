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
        // 重複して存在する場合は削除してから追加する
        if historyIds.contains(songId) {
            historyIds.removeAll(where: {$0 == songId})
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
