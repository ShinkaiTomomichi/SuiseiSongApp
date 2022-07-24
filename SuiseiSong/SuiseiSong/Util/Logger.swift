//
//  Util.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/18.
//

import Foundation

struct Logger {
    static func log(message: Any, style: String = "debug") {
        print("[debug] \(message)")
    }
}

// TODO: enum型でログの種類を制御したい
