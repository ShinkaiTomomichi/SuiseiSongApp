//
//  NotificationName.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/23.
//

import Foundation

// TODO: 雑に管理しているがもっといい方法はないか
extension NSNotification.Name {
    static let didChangedSelectedSong = Notification.Name("didChangedSelectedSong")
    
    static let didChangedRepeatType = Notification.Name("didChangedRepeatType")
    
    static let didChangedPlaying = Notification.Name("didChangedPlaying")    
}
