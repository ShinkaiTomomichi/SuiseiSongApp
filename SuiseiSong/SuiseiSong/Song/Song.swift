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
    var songname: String
    var artistname: String
    var starttime: Int
    var endtime: Int
    var members: [String]
    var videoid: String
    var date: Int
    var collaboration: Bool
    var acappella: Bool
    var live3d: Bool
    var suisei: Bool
    var stream: Bool
    var listtype: String
    // 独自に追加する情報
    var favorite: Bool
    var filter: Bool
    var choice: Bool
    
    init(songForJSON: SongForJSON) {
        self.id = songForJSON.id
        self.songname = songForJSON.songname
        self.artistname = songForJSON.artistname
        self.starttime = songForJSON.starttime
        self.endtime = songForJSON.endtime
        self.members = songForJSON.members.components(separatedBy: ",")
        self.videoid = songForJSON.videoid
        self.date = songForJSON.date
        self.collaboration = songForJSON.collaboration
        self.acappella = songForJSON.acappella
        self.live3d = songForJSON.live3d
        self.suisei = songForJSON.suisei
        self.stream = songForJSON.stream
        self.listtype = songForJSON.listtype
        // 以下独自の値を利用する
        self.favorite = false
        self.filter = false
        self.choice = false        
    }
    
    // IDが一致するものは同じとする
    static func == (lhs: Song, rhs: Song) -> Bool {
        return lhs.id == rhs.id
    }
}
