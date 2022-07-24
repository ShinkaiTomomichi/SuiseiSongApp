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
    // filterごとに機能していると話にならん
    // filterdごとにselectedが定義されているのがまずいかも
    // というか自動再生とそうじゃない場合の場合分けがしたい
    private(set) var filteredSongs: [Song] = [] {
        didSet {
            NotificationCenter.default.post(name: .didChangedFilteredSong, object: nil)
            if filteredSongs.count != 0 {
                SelectedStatus.shared.setSelectedID()
            } else {
                SelectedStatus.shared.setSelectedID(id: nil)
            }
        }
    }
    
    func setup() {
        guard YTPlayerViewWrapper.shared.playerView != nil else {
            Logger.log(message: "setupの前にplayerViewのセットを実施して下さい")
            return
        }
        self.allSongs = JSONFileManager.getSuiseiSongs()
        self.filteredSongs = self.allSongs
    }
    
    // filter機能はテストを実装しておきたい
    func filter(by: String!) {
        var filteredSongsTmp: [Song] = []
        guard !by.isEmpty else {
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
    
    // これサーチの二重がけとかどう管理しようか？
    func shuffle() {
        let filteredSongsTmp = self.allSongs.shuffled()
        self.filteredSongs = filteredSongsTmp
    }
}
