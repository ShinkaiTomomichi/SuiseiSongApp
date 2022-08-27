//
//  Song.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/14.
//

import Foundation
import UIKit

// お気に入り情報を単一ソースで管理するためclassにする
final class Song: Equatable {
    // JSONから取得する情報
    var id: Int
    var members: [String]
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
    // 独自に追加する情報
    var favorite: Bool
    var filter: Bool
    
    init(songForJSON: SongForJSON) {
        self.id = songForJSON.id
        self.members = songForJSON.members.components(separatedBy: ",")
        self.videoid = songForJSON.videoid
        self.artisturl = songForJSON.artisturl
        self.collaboration = songForJSON.collaboration
        self.anime = songForJSON.anime
        self.rock = songForJSON.rock
        self.vocaloid = songForJSON.vocaloid
        self.acappella = songForJSON.acappella
        self.live3d = songForJSON.live3d
        self.live3d = songForJSON.live3d
        self.date = songForJSON.date
        // 以下修正した値を利用する
        self.songtitle = songForJSON.songnameremake
        self.starttime = songForJSON.starttimeremake
        self.endtime = songForJSON.endtimeremake
        self.artist = songForJSON.artistnameremake
        // 以下独自の値を利用する
        self.favorite = false
        self.filter = false
    }
    
    // IDが一致するものは同じとする
    static func == (lhs: Song, rhs: Song) -> Bool {
        return lhs.id == rhs.id
    }
}
