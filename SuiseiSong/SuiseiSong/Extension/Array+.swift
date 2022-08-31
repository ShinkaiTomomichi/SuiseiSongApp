//
//  Array+.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/08/31.
//

import Foundation

extension Array where Element == String {
    func uniqueSortedByCount() -> [String] {
        var counts = [String:Int]()
        for item in self {
            counts[item] = (counts[item] ?? 0) + 1
        }
        return counts.sorted { $0.1 > $1.1 } .map { $0.0 }
    }
    
    func uniqueSortedByName() -> [String] {
        var tmp: [String] = []
        for item in self {
            if !tmp.contains(item) {
                tmp.append(item)
            }
        }
        return tmp.sorted { $0 > $1 }
    }
    
    func unique() -> [String] {
        var tmp: [String] = []
        for item in self {
            if !tmp.contains(item) {
                tmp.append(item)
            }
        }
        return tmp
    }
}
