//
//  Song.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/14.
//

import Foundation

struct Song: Codable {
    var videoid: String
    var songtitle: String
    var artist: String
    var starttime: Int
    var endtime: Int
    
    func calcDuration() -> Int{
        return endtime - starttime
    }
}
