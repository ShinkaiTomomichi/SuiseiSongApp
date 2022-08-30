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
    var filteredSongs: [Song] = []
    private(set) var displaySongs: [Song] = [] {
        didSet {
            self.displaySongsForSearch = displaySongs
        }
    }
    var displaySongsForSearch: [Song] = []
    // 暫定的なジャンル分け
    var collabSongs: [Song] = []
    var live3DSongs: [Song] = []
    // 暫定的なホロメン分け
    // TODO: JSONでメンバーリストを控えておく
    let holoMembers: [String] = ["天音かなた", "常闇トワ", "桃鈴ねね", "宝鐘マリン", "湊あくあ"]
    var holoMembersSongs: [String: [Song]] = [:]
    
    let myFavorites: [String] = ["8月のおすすめ", "7月のおすすめ", "6月のおすすめ"]
    var myFavoriteSongs: [String: [Song]] = [:]
    
    // TODO: 暫定的なアーティスト分け
    let artists: [String] = []
    var artistsSongs: [String: [Song]] = [:]
    // お気に入りと履歴
    var favoriteSongs: [Song] = []
    var historySongs: [Song] = []
    
    func setup() {
        setupAllSongs()
        setupFilteredSongs()
        setupOtherSongs()
        setupHoloMeberSongs()
        setupMyFavoriteSongs()
        
        resetDisplaySongs()
        ImageCaches.shared.setup()
        
        // debug
        checkIdForDebug()
    }
    
    private func setupAllSongs() {
        self.allSongs = JSONFileManager.getSuiseiSongs(forResource: "suisei_songs")
        
        sortAllSongs()
        setFavoriteAllSongs()
    }
    
    // TODO: 投稿日が同じだと不適当なソートになる
    private func sortAllSongs() {
        allSongs.sort { $0.date-$0.starttime > $1.date-$1.starttime }
    }
    
    private func setupFilteredSongs() {
        removeDuplication(enable: Settings.shared.filteredDuplication)
        removeAcappella(enable: Settings.shared.filteredAcappella)
        removeNotSuisei(enable: true)
        filteredSongs = allSongs.filter { !$0.filter }
    }
    
    private func removeDuplication(enable: Bool) {
        var songTitles: [String] = []
        for song in allSongs {
            if song.members.count == 1 && songTitles.contains(song.songname) {
                song.filter = enable
            } else if song.members.count == 1 {
                songTitles.append(song.songname)
            }
        }
    }
    
    private func removeAcappella(enable: Bool) {
        for song in allSongs {
            if song.acappella {
                song.filter = enable
            }
        }
    }
    
    // TODO: 別途フラグを用意したい
    private func removeNotSuisei(enable: Bool) {
        for song in allSongs {
            if !song.suisei {
                song.filter = enable
            }
        }
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
        collabSongs = filteredSongs.filter { $0.collaboration }
        live3DSongs = filteredSongs.filter { $0.live3d }
        // お気に入りと履歴をセット
        favoriteSongs = allSongs.filter {
            Favorites.shared.favoriteIds.contains($0.id)
        }
        historySongs = allSongs.filter {
            Histories.shared.historyIds.contains($0.id)
        }
        
        sortOtherSongs()
    }
    
    // reload時に呼び出すためpublicにする
    func sortOtherSongs() {
        // 表示順のIDを返す仕様とする
        // recommendから任意のIDを返せるようにする
        let collabIds = Recommend.randomize(songs: collabSongs)
        collabSongs = sorted(byIds: collabIds)
        let live3DIds = Recommend.randomize(songs: live3DSongs)
        live3DSongs = sorted(byIds: live3DIds)
        
        // 履歴とお気に入りは追加順で固定
        favoriteSongs = sorted(byIds: Favorites.shared.favoriteIds.reversed())
        historySongs = sorted(byIds: Histories.shared.historyIds.reversed())
    }
    
    private func sorted(byIds: [Int]) -> [Song] {
        return byIds.map { getSong(byId: $0) }
    }
    
    private func setupHoloMeberSongs() {
        for holoMember in holoMembers {
            holoMembersSongs[holoMember] = filteredSongs.filter {
                $0.members.contains(holoMember)
            }
        }
    }
    
    private func setupMyFavoriteSongs() {
        for myFavorite in myFavorites {
            myFavoriteSongs[myFavorite] = allSongs.filter {
                $0.listtype == myFavorite
            }
        }
    }
    
    func resetDisplaySongs() {
        self.displaySongs = self.filteredSongs
    }
    
    // 現状allSongsを別に切り出している
    // allSongsを一つにまとめたい
    // TODO: IDを変えた時にクラッシュするので修正する
    // 動画が消える場合を想定しなくてはならない
    func getSong(byId: Int) -> Song {
        return allSongs.filter { $0.id == byId }[0]
    }
    
    // 前後移動のためdisplaySongsにおける順番を取得
    func getFilteredId(bySong: Song) -> Int {
        if let index = displaySongs.firstIndex(of: bySong) {
            return index
        } else {
            fatalError("indexの取得に失敗しました")
        }
    }
        
    func shuffleDisplaySongsExpectSelectedSong() {
        var displaySongsTmp = self.displaySongs.shuffled()
        if let selectedSong = SelectedStatus.shared.song {
            displaySongsTmp.removeAll(where: {$0 == selectedSong})
            displaySongsTmp.insert(selectedSong, at: 0)
        } else {
            Logger.log(message: "selectedSongが存在しません")
        }
        self.displaySongs = displaySongsTmp
        if let selectedSong = SelectedStatus.shared.song {
            SelectedStatus.shared.setSelectedSong(song: selectedSong)
        }
    }
    
    func setDisplaySongs(songs: [Song]) {
        self.displaySongs = songs
    }
    
    func setDisplaySongsForSearch(by: String!) {
        guard !by.isEmpty else {
            self.displaySongsForSearch = displaySongs
            return
        }
        displaySongsForSearch = displaySongs.filter {
            $0.songname.contains(by) || $0.artistname.contains(by)
        }
    }
    
    func resetChoicies() {
        for song in allSongs {
            song.choice = false
        }
    }
    
    private func checkIdForDebug() {
        var ids: [Int] = []
        for song in allSongs {
            if ids.contains(song.id) {
                Logger.log(message: "不正なIDがあります")
            }
            ids.append(song.id)
        }
    }
}
