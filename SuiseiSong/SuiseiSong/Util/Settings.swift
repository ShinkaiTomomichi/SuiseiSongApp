//
//  Settings.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/23.
//

import Foundation

// TODO: 永続化するためにUserDefaultsやRealmを使う
// Settingsのようなカラム管理が不要なものはUDで良さそう
final class Settings {
    static var shared = Settings()
    private init() {}

    var repeatType: RepeatType = .none {
        didSet {
            NotificationCenter.default.post(name: .didChangedRepeatType, object: nil)
        }
    }
    
    func toggleRepeatType() {
        if repeatType == .none {
            repeatType = .allRepeat
        } else if repeatType == .allRepeat {
            repeatType = .singleRepeat
        } else {
            repeatType = .none
        }
    }
}

enum RepeatType {
    case none
    case allRepeat
    case singleRepeat
}
