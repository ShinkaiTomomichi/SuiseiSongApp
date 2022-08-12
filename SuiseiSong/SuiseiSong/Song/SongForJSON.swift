//
//  SongForJSON.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/08/09.
//

import Foundation

struct SongForJSON: Codable {
    var id: Int
    var members: String
    var videoid: String
    var songtitle: String
    var starttime: Int
    var endtime: Int
    var artist: String
    var artisturl: String
    var collaboration: Bool
    var anime: Bool
    var rock: Bool
    var vocaloid: Bool
    var acappella: Bool
    var live3d: Bool
    var date: Int
    
    func calcDuration() -> Int{
        return endtime - starttime
    }
}
