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

    var shouldRepeat: Bool = false
    var shouldSingleRepeat: Bool = false
}
