//
//  Song.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/14.
//

import Foundation
import UIKit

// キャッシュを入れるためCodableではないstructを新たに作成
struct Song {
    // JSONから取得する情報
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
    
    // アプリの中で付与する情報
    // var thumbnail: UIImage? // videoIdごとの管理で十分
    var favorite: Bool
    var debugCheck: Bool // タイムスタンプが正しい場合にはTrueを返す（UD保存か？）
    
    init(songForJSON: SongForJSON) {
        self.id = songForJSON.id
        self.members = songForJSON.members
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
        self.favorite = false
        self.debugCheck = false
        
        // 以下修正
        self.songtitle = songForJSON.songnameremake
        self.starttime = songForJSON.starttimeremake
        self.endtime = songForJSON.endtimeremake
        self.artist = songForJSON.artistnameremake
        
    }
}
