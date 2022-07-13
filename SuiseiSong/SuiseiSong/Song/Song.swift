//
//  Song.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/14.
//

import Foundation

struct Song {
    var title: String!
    var start: Int!
    var end: Int!
    
    func calcDuration() -> Int{
        return end - start
    }
}
