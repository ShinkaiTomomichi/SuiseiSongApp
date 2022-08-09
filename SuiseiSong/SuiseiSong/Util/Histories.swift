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
    var historyIds: [String] = {
        UserDefaults.loadHistory()
    }() ?? []
    private init() {}
    
    func addHistory(videoId: String) {
        historyIds.append(videoId)
        if historyIds.count > maxSize {
            rotateHistory()
        }
        NotificationCenter.default.post(name: .didChangedHistory, object: nil)
    }
    
    func rotateHistory() {
        let removeSize = historyIds.count - maxSize
        historyIds.removeSubrange(0...removeSize)
    }
}
