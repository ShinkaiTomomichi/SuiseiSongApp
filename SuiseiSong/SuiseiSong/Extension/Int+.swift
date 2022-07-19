//
//  Int+.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/19.
//

import Foundation

extension Int {
    func toTimeStamp() -> String {
        let min = self / 60
        let sec = self % 60
        return "\(String(format: "%01d", min)):\(String(format: "%02d", sec))"
    }
}
