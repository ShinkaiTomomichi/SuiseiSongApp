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
    let holoMembers: [String] = ["天音かなた", "常闇トワ", "桃鈴ねね", "宝鐘マリン", "湊あくあ"]
    var holoMembersSongs: [String: [Song]] = [:]
    
    // TODO: 暫定的なアーティスト分け
    let artists: [String] = []
    var artistsSongs: [String: [Song]] = [:]
    // お気に入りと履歴
    var favoriteSongs: [Song] = []
    var historySongs: [Song] = []
    
    func setup() {
        setupAllSongs()
        setupOtherSongs()
        setupHoloMeberSongs()
        
        resetFilteredSong()
        ImageCaches.shared.setup()
    }
    
    private func setupAllSongs() {
        self.allSongs = JSONFileManager.getSuiseiSongs(forResource: "suisei_song3")
        sortAllSongs()
        setFavoriteAllSongs()
    }
    
    private func sortAllSongs() {
        allSongs.sort { $0.date-$0.starttime > $1.date-$1.starttime }
    }
    
    private func setFavoriteAllSongs() {
        for song in allSongs {
            if Favorites.shared.favoriteIds.contains(song.id) {
                song.favorite = true
            }
        }
    }
    
    private func setupOtherSongs() {
        // 特定のジャンルの動画をセット
        collabSongs = allSongs.filter { $0.collaboration }
        animeSongs = allSongs.filter { $0.anime }
        vocaloidSongs = allSongs.filter { $0.vocaloid }
        rockSongs = allSongs.filter { $0.rock }
        live3DSongs = allSongs.filter { $0.live3d }
        // お気に入りと履歴をセット
        favoriteSongs = allSongs.filter {
            Favorites.shared.favoriteIds.contains($0.id)
        }
        historySongs = allSongs.filter {
            Histories.shared.historyIds.contains($0.id)
        }
        // 他のデータベースから動画をセット
        favorite202207Songs = JSONFileManager.getSuiseiSongs(forResource: "202207")
        favorite202206Songs = JSONFileManager.getSuiseiSongs(forResource: "202206")
        
        sortOtherSongs()
    }
    
    // reload時に呼び出すためpublicにする
    func sortOtherSongs() {
        // 表示順のIDを返す仕様とする
        // recommendから任意のIDを返せるようにする
        let collabIds = Recommend.randomize(songs: collabSongs)
        collabSongs = sorted(byIds: collabIds)
        let animeIds = Recommend.randomize(songs: animeSongs)
        animeSongs = sorted(byIds: animeIds)
        let vocaloidIds = Recommend.randomize(songs: vocaloidSongs)
        vocaloidSongs = sorted(byIds: vocaloidIds)
        let rockIds = Recommend.randomize(songs: rockSongs)
        rockSongs = sorted(byIds: rockIds)
        let live3DIds = Recommend.randomize(songs: live3DSongs)
        live3DSongs = sorted(byIds: live3DIds)
        
        // 履歴とお気に入りは追加順で固定
        favoriteSongs = sorted(byIds: Favorites.shared.favoriteIds.reversed())
        historySongs = sorted(byIds: Histories.shared.historyIds.reversed())
    }
    
    private func sorted(byIds: [Int]) -> [Song] {
        return byIds.map { get(byId: $0) }
    }
    
    private func setupHoloMeberSongs() {
        for holoMember in holoMembers {
            holoMembersSongs[holoMember] = allSongs.filter {
                $0.members.contains(holoMember)
            }
        }
    }
    
    func resetFilteredSong() {
        self.filteredSongs = self.allSongs
    }
    
    // 現状allSongsを別に切り出している
    // allSongsを一つにまとめたい
    func get(byId: Int) -> Song {
        let songsList = [allSongs, favorite202207Songs, favorite202206Songs]
        for songs in songsList {
            for song in songs {
                if song.id == byId {
                    return song
                }
            }
        }
        fatalError()
    }
    
    // 前後の動画に移行する際にfilteredIDを利用
    // これが存在しない場合はErrorで停止させる
    func getFilteredID(bySong: Song) -> Int {
        for (index, filteredSong) in filteredSongs.enumerated() {
            if bySong.id == filteredSong.id {
                return index
            }
        }
        fatalError()
    }
    
    func shuffleFilteredSongsExpectSelectedSong() {
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
    
    // filter機能はテストを実装しておきたい
    func setFilteredSongsForSearch(by: String!) {
        guard !by.isEmpty else {
            self.filteredSongsForSearch = filteredSongs
            return
        }
        filteredSongsForSearch = filteredSongs.filter {
            $0.songtitle.contains(by) || $0.artist.contains(by)
        }
    }
}
