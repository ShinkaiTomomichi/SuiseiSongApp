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
            self.filteredSongsForSearch = filteredSongs
        }
    }
    var filteredSongsForSearch: [Song] = []
    
    // 重くないのであればジャンルごとのリストは最初から保持しておく
    var favorite202207Songs: [Song] = []
    var favorite202206Songs: [Song] = []
    // header用に10件ほど格納する
    var collabSongs: [Song] = []
    var live3DSongs: [Song] = []
    var animeSongs: [Song] = []
    var rockSongs: [Song] = []
    var vocaloidSongs: [Song] = []
    var originalSongs: [Song] = []
    var favoriteSongs: [Song] = []
    var historySongs: [Song] = []
    
    func setup() {
        self.allSongs = JSONFileManager.getSuiseiSongs(forResource: "suisei_song2")
        setFavorites()
        sortAllSongs()

        // お気に入りに入れた動画を復元
        self.favorite202207Songs = JSONFileManager.getSuiseiSongs(forResource: "202207")
        self.favorite202206Songs = JSONFileManager.getSuiseiSongs(forResource: "202206")

        setHeaders()
        
        // allSongsに一元管理しないとお気に入り管理がとても面倒
        self.filteredSongs = self.allSongs
        ImageCaches.shared.setup()
    }
    
    func get(byID: Int) -> Song {
        let songsList = [allSongs, favorite202207Songs, favorite202206Songs]
        for songs in songsList {
            for song in songs {
                if song.id == byID {
                    return song
                }
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
            self.filteredSongsForSearch = filteredSongs
            return
        }
        for song in filteredSongs {
            if song.songtitle.contains(by) || song.artist.contains(by) {
                filteredSongsTmp.append(song)
            }
        }
        self.filteredSongsForSearch = filteredSongsTmp
    }
    
    // そのまま実行するとfiltererIDの管理が面倒になる
    // 仕様自体を考え直した方が良さそう
    func shuffle() {
        var filteredSongsTmp = self.filteredSongs.shuffled()
        if let selectedSong = SelectedStatus.shared.song {
            filteredSongsTmp.removeAll(where: {$0.id == selectedSong.id})
            filteredSongsTmp.insert(selectedSong, at: 0)
        } else {
            Logger.log(message: "selectedSongが存在しません")
        }
        self.filteredSongs = filteredSongsTmp
        if let selectedSong = SelectedStatus.shared.song {
            SelectedStatus.shared.setSelectedSong(song: selectedSong)
        }
    }
    
    func setFilteredSongs(songs: [Song]) {
        self.filteredSongs = songs
    }
    
    func reset() {
        self.filteredSongs = self.allSongs
    }
    
    func getSongs(byFilterType: FilterType) -> [Song] {
        var tmpSongs: [Song] = []
        for song in allSongs {
            switch byFilterType {
            case .collaboration:
                if song.collaboration {
                    tmpSongs.append(song)
                }
            case .anime:
                if song.anime {
                    tmpSongs.append(song)
                }
            case .rock:
                if song.rock {
                    tmpSongs.append(song)
                }
            case .live3d:
                if song.live3d {
                    tmpSongs.append(song)
                }
            case .vocaloid:
                if song.vocaloid {
                    tmpSongs.append(song)
                }
            case .favorite:
                if Favorites.shared.favoriteIds.contains(song.id) {
                    tmpSongs.append(song)
                }
            case .history:
                if Histories.shared.historyIds.contains(song.id) {
                    tmpSongs.append(song)
                }
            }
        }
        return tmpSongs
    }
    
    func setHeaders() {
        // 最新の動画順になるため順序を検討したい
        for song in allSongs {
            if song.collaboration && collabSongs.count < 10 {
                collabSongs.append(song)
            }
            if song.anime && animeSongs.count < 10  {
                animeSongs.append(song)
            }
            if song.rock && rockSongs.count < 10  {
                rockSongs.append(song)
            }
            if song.live3d && live3DSongs.count < 10 {
                live3DSongs.append(song)
            }
            if song.vocaloid && vocaloidSongs.count < 10 {
                vocaloidSongs.append(song)
            }
            if Favorites.shared.favoriteIds.contains(song.id) && favoriteSongs.count < 10 {
                favoriteSongs.append(song)
            }
            if Histories.shared.historyIds.contains(song.id) && historySongs.count < 10 {
                historySongs.append(song)
            }
        }
    }
    
    func resetHeaders() {
        favoriteSongs.removeAll()
        historySongs.removeAll()
        for song in allSongs {
            if Favorites.shared.favoriteIds.contains(song.id) && favoriteSongs.count < 10 {
                favoriteSongs.append(song)
            }
            if Histories.shared.historyIds.contains(song.id) && historySongs.count < 10 {
                historySongs.append(song)
            }
        }
    }
    
    func sortAllSongs() {
        allSongs.sort { $0.date-$0.starttime > $1.date-$1.starttime }
    }
    
    func setFavorites() {
        for (i, song) in allSongs.enumerated() {
            if Favorites.shared.favoriteIds.contains(song.id) {
                allSongs[i].favorite = true
            }
        }
    }
    
    func setFavorite(songId: Int, favorite: Bool) {
        for (i, song) in allSongs.enumerated() {
            if song.id == songId {
                allSongs[i].favorite = favorite
            }
        }
    }
    
    func setupFavoriteSongs() {
        Logger.log(message: "未実装")
    }
    
    func updateFavoriteSongs() {
        Logger.log(message: "未実装")
    }
}

enum FilterType {
    case collaboration
    case anime
    case rock
    case live3d
    case vocaloid
    case favorite
    case history
}
