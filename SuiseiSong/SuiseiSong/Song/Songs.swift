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
    // 暫定的に用意した個人的なお気に入り
    var favorite202207Songs: [Song] = []
    var favorite202206Songs: [Song] = []
    // 暫定的なジャンル分け
    var collabSongs: [Song] = []
    var live3DSongs: [Song] = []
    var animeSongs: [Song] = []
    var rockSongs: [Song] = []
    var vocaloidSongs: [Song] = []
    var originalSongs: [Song] = []
    // 暫定的なホロメン分け
    // TODO: JSONでメンバーリストを控えておく
    let holomembers: [String] = ["天音かなた", "常闇トワ", "桃鈴ねね", "宝鐘マリン", "湊あくあ"]
    var holomembersSongs: [String: [Song]] = [:]
    
    var kanataSongs: [Song] = []
    var towaSongs: [Song] = []
    var neneSongs: [Song] = []
    var marineSongs: [Song] = []
    var aquaSongs: [Song] = []
    // TODO: 暫定的なアーティスト分け
    // お気に入りと履歴
    var favoriteSongs: [Song] = []
    var historySongs: [Song] = []
    
    func setup() {
        self.allSongs = JSONFileManager.getSuiseiSongs(forResource: "suisei_song3")
        sortAllSongs()
        
        setFavorites()
        setOtherSongs()
        sortOtherSongs()
        
        setHolomemberSongs()

        // お気に入りに入れた動画を復元
        self.favorite202207Songs = JSONFileManager.getSuiseiSongs(forResource: "202207")
        self.favorite202206Songs = JSONFileManager.getSuiseiSongs(forResource: "202206")
        
        // allSongsに一元管理しないとお気に入り管理がとても面倒
        self.filteredSongs = self.allSongs
        ImageCaches.shared.setup()
        ImageCaches.shared.setupHolomembers()
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
    
    // あーソートすると最初の段階で保持しないといけないのか...
    // 全部保持する形に戻すか？
    // scoreを可変にする以上持っていた方が楽な気がするが...
    // 画像さえ持っていなければいいかな？
    func setOtherSongs() {
        // 最新の動画順になるため順序を検討したい
        for song in allSongs {
            if song.collaboration {
                collabSongs.append(song)
            }
            if song.anime {
                animeSongs.append(song)
            }
            if song.rock {
                rockSongs.append(song)
            }
            if song.live3d {
                live3DSongs.append(song)
            }
            if song.vocaloid {
                vocaloidSongs.append(song)
            }
            
            if Favorites.shared.favoriteIds.contains(song.id) {
                favoriteSongs.append(song)
            }
            if Histories.shared.historyIds.contains(song.id) {
                historySongs.append(song)
            }
        }
    }
    
    func setHolomemberSongs() {
        for holomember in holomembers {
            holomembersSongs[holomember] = []
        }
        for song in allSongs {
            for holomember in holomembers {
                if song.members.contains(holomember) {
                    holomembersSongs[holomember]?.append(song)
                }
            }
        }
    }
    
    func resetHeaders() {
        favoriteSongs.removeAll()
        historySongs.removeAll()
        for song in allSongs {
            if Favorites.shared.favoriteIds.contains(song.id) {
                favoriteSongs.append(song)
            }
            if Histories.shared.historyIds.contains(song.id) {
                historySongs.append(song)
            }
        }
        for (i, song) in favoriteSongs.enumerated() {
            if let score = Favorites.shared.favoriteIds.firstIndex(of: song.id) {
                favoriteSongs[i].score = Double(score)
            }
        }
        for (i, song) in historySongs.enumerated() {
            if let score = Histories.shared.historyIds.firstIndex(of: song.id) {
                historySongs[i].score = Double(score)
            }
        }
        favoriteSongs.sort { $0.score > $1.score }
        historySongs.sort { $0.score > $1.score }
    }
    
    func sortAllSongs() {
        allSongs.sort { $0.date-$0.starttime > $1.date-$1.starttime }
    }
    
    func sortOtherSongs() {
        for (i, _) in collabSongs.enumerated() {
            let score = Double.random(in: 0...1)
            collabSongs[i].score = score
        }
        for (i, _) in animeSongs.enumerated() {
            let score = Double.random(in: 0...1)
            animeSongs[i].score = score
        }
        for (i, _) in rockSongs.enumerated() {
            let score = Double.random(in: 0...1)
            rockSongs[i].score = score
        }
        for (i, _) in live3DSongs.enumerated() {
            let score = Double.random(in: 0...1)
            live3DSongs[i].score = score
        }
        for (i, _) in vocaloidSongs.enumerated() {
            let score = Double.random(in: 0...1)
            vocaloidSongs[i].score = score
        }
        for (i, song) in favoriteSongs.enumerated() {
            if let score = Favorites.shared.favoriteIds.firstIndex(of: song.id) {
                favoriteSongs[i].score = Double(score)
            }
        }
        for (i, song) in historySongs.enumerated() {
            if let score = Histories.shared.historyIds.firstIndex(of: song.id) {
                historySongs[i].score = Double(score)
            }
        }
        collabSongs.sort { $0.score > $1.score }
        animeSongs.sort { $0.score > $1.score }
        rockSongs.sort { $0.score > $1.score }
        live3DSongs.sort { $0.score > $1.score }
        vocaloidSongs.sort { $0.score > $1.score }
        favoriteSongs.sort { $0.score > $1.score }
        historySongs.sort { $0.score > $1.score }
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

enum SortType {
    case random
    case favorite
    case history
}
