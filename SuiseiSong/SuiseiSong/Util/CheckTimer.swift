//
//  checkTime.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/09/02.
//

import Foundation

struct CheckTimer {    
    private var isStarted: Bool = false
    private var startTime: Double?
    private var endTime: Double?
    
    mutating func check(handler: () -> (), comment: String? = nil) {
        guard !isStarted else {
            Logger.log(message: "計測を開始できませんでした")
            return
        }
        isStarted = true
        var date: Date = Date()
        startTime = date.timeIntervalSince1970
        
        handler()
        
        date = Date()
        endTime = date.timeIntervalSince1970
        if let comment = comment {
            Logger.log(message: comment)
        }
        Logger.log(message: "経過時間:\(endTime!-startTime!)")
        isStarted = false
    }
}
