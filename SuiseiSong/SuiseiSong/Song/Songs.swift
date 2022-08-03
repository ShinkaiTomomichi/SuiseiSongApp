//
//  Songs.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/21.
//

import Foundation

// 構造体だとアウト
final class Songs {
    static var shared = Songs()
    private init() {}
    
    // allSongsは特に更新しない
    var allSongs: [Song] = []
    private(set) var filteredSongs: [Song] = [] {
        didSet {
            NotificationCenter.default.post(name: .didChangedFilteredSong, object: nil)
        }
    }
    
    // 重くないのであればジャンルごとのリストは最初から保持しておく
    var favorite202207Songs: [Song] = []
    var favorite202206Songs: [Song] = []
    var collabSongs: [Song] = []
    var Live3DSongs: [Song] = []
    var originalSongs: [Song] = []
    
    func setup() {
        self.allSongs = JSONFileManager.getSuiseiSongs(forResource: "suisei_song2")
        self.favorite202207Songs = JSONFileManager.getSuiseiSongs(forResource: "202207")
        self.favorite202206Songs = JSONFileManager.getSuiseiSongs(forResource: "202206")
        self.filteredSongs = self.allSongs
    }
    
    func get(byID: Int) -> Song {
        for song in allSongs {
            if song.id == byID {
                return song
            }
        }
        for song in favorite202207Songs {
            if song.id == byID {
                return song
            }
        }
        for song in favorite202206Songs {
            if song.id == byID {
                return song
            }
        }
        fatalError()
    }
    
    // これが存在しない場合はErrorで停止させる
    func getFilteredID(bySong: Song) -> Int {
        for (index, filteredSong) in filteredSongs.enumerated() {
            if bySong.id == filteredSong.id {
                return index
            }
        }
        fatalError()
    }
    
    // filter機能はテストを実装しておきたい
    func filter(by: String!) {
        var filteredSongsTmp: [Song] = []
        guard !by.isEmpty else {
            // TODO: 全動画ではなく初期値が出るように変えたい
            // filtered2の中身を変えるなど段階を分ける
            self.filteredSongs = allSongs
            return
        }
        for song in allSongs {
            if song.songtitle.contains(by) || song.artist.contains(by) {
                filteredSongsTmp.append(song)
            }
        }
        self.filteredSongs = filteredSongsTmp
    }

    func filter(bySongTitle: String!) {
        var filteredSongsTmp: [Song] = []
        guard !bySongTitle.isEmpty else {
            self.filteredSongs = allSongs
            return
        }
        for song in allSongs {
            if song.songtitle.contains(bySongTitle) {
                filteredSongsTmp.append(song)
            }
        }
        self.filteredSongs = filteredSongsTmp
    }
    
    func filter(byArtist: String!) {
        guard !byArtist.isEmpty else {
            self.filteredSongs = allSongs
            return
        }
        var filteredSongsTmp: [Song] = []
        for song in allSongs {
            if song.artist.contains(byArtist) {
                filteredSongsTmp.append(song)
            }
        }
        self.filteredSongs = filteredSongsTmp
    }
    
    // そのまま実行するとfiltererIDの管理が面倒になる
    // 仕様自体を考え直した方が良さそう
    func shuffle() {
        let filteredSongsTmp = self.filteredSongs.shuffled()
        self.filteredSongs = filteredSongsTmp
    }
    
    func setFilteredSongs(songs: [Song]) {
        self.filteredSongs = songs
    }
    
    func reset() {
        self.filteredSongs = self.allSongs
    }
}
