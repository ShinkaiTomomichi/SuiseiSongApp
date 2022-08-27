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
        setupFilteredSongs()
        setupOtherSongs()
        setupHoloMeberSongs()
        
        resetDisplaySongs()
        ImageCaches.shared.setup()
        
        // debug
        checkIdForDebug()
    }
    
    private func setupAllSongs() {
        self.allSongs = JSONFileManager.getSuiseiSongs(forResource: "suisei_song3")
        allSongs.append(contentsOf: JSONFileManager.getSuiseiSongs(forResource: "202207"))
        allSongs.append(contentsOf: JSONFileManager.getSuiseiSongs(forResource: "202206"))
        
        sortAllSongs()
        setFavoriteAllSongs()
    }
    
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
            if song.members.count == 1 && songTitles.contains(song.songtitle) {
                song.filter = enable
            } else if song.members.count == 1 {
                songTitles.append(song.songtitle)
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
            if song.id > 10000 {
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
        animeSongs = filteredSongs.filter { $0.anime }
        vocaloidSongs = filteredSongs.filter { $0.vocaloid }
        rockSongs = filteredSongs.filter { $0.rock }
        live3DSongs = filteredSongs.filter { $0.live3d }
        // お気に入りと履歴をセット
        favoriteSongs = allSongs.filter {
            Favorites.shared.favoriteIds.contains($0.id)
        }
        historySongs = allSongs.filter {
            Histories.shared.historyIds.contains($0.id)
        }
        // 別で追加する
        favorite202207Songs = allSongs.filter { $0.id >= 20220700 && $0.id < 20220800 }
        favorite202206Songs = allSongs.filter { $0.id >= 20220600 && $0.id < 20220700 }
        
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
        return byIds.map { getSong(byId: $0) }
    }
    
    private func setupHoloMeberSongs() {
        for holoMember in holoMembers {
            holoMembersSongs[holoMember] = filteredSongs.filter {
                $0.members.contains(holoMember)
            }
        }
    }
    
    func resetDisplaySongs() {
        self.displaySongs = self.filteredSongs
    }
    
    // 現状allSongsを別に切り出している
    // allSongsを一つにまとめたい
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
            $0.songtitle.contains(by) || $0.artist.contains(by)
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
