//
//  Song.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/14.
//

import Foundation

//struct Song: Codable {
//    var videoid: String
//    var songtitle: String
//    var artist: String
//    var starttime: Int
//    var endtime: Int
//
//    func calcDuration() -> Int{
//        return endtime - starttime
//    }
//}

struct Song: Codable {
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
    
    func calcDuration() -> Int{
        return endtime - starttime
    }
}
