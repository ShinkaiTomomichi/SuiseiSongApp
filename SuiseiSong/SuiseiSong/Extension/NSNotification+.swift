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
    
    static let didChangedFilteredSong = Notification.Name("didChangedFilteredSong")
    
    static let didChangedRepeatType = Notification.Name("didChangedRepeatType")
    
    static let didChangedPlaying = Notification.Name("didChangedPlaying")
    
    static let didChangedFavorite = Notification.Name("didChangedFavorite")
    
    static let didChangedHistory = Notification.Name("didChangedHistory")
}
