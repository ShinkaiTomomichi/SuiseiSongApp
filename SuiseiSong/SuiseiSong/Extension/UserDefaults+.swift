//
//  UserDefaults.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/08/05.
//

import Foundation

extension UserDefaults {
    
    static func saveModifiedTime(id: Int, startTime: Int, endTime: Int) {
        let idString = "modified:"+String(id)
        let value = String(startTime) + "&" + String(endTime)
        UserDefaults.standard.set(value, forKey: idString)
    }
    
    static func printAll() {
        UserDefaults.standard.dictionaryRepresentation().forEach {
            let key = $0.key
            if key.contains("modified:") {
                let value = $0.value as! String
                Logger.log(message: "key:\(key), value:\(value)")
            }
        }
    }
    
    static func removeAll() {
        UserDefaults.standard.dictionaryRepresentation().forEach {
            UserDefaults.standard.removeObject(forKey: $0.key)
        }
    }
}
