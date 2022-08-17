//
//  SongForJSON.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/08/09.
//

import Foundation

// メモリが大きい気がするので
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
    var songnameremake: String
    var artistnameremake: String
    var starttimeremake: Int
    var endtimeremake: Int
    
    func calcDuration() -> Int{
        return endtime - starttime
    }
}
