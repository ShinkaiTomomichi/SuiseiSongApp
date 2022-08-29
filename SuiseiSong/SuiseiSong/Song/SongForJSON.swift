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
    var songname: String
    var artistname: String
    var starttime: Int
    var endtime: Int
    var members: String
    var videoid: String
    var date: Int
    var collaboration: Bool
    var acappella: Bool
    var live3d: Bool
    var suisei: Bool
    var stream: Bool
    var listtype: String
    
    func calcDuration() -> Int{
        return endtime - starttime
    }
}
