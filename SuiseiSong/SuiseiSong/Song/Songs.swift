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
    
    // ジャンルごとにリスト化
    var notStreamSongs: [Song] = []
    var live3DSongs: [Song] = []
    
    // ホロメンごとにリスト化
    var holoMembers: [String] = []
    var holoMembersSongs: [String: [Song]] = [:]
    // 月ごとのお気に入りでリスト化
    var myFavorites: [String] = []
    var myFavoriteSongs: [String: [Song]] = [:]
    // アーティストごとでリスト化
    var artists: [String] = []
    var artistsSongs: [String: [Song]] = [:]
    // プレイリスト
    var playList: [String] = []
    var playListSongs: [String: [Song]] = [:]
    // お気に入りと履歴
    var favoriteSongs: [Song] = []
    var historySongs: [Song] = []
    
    func setup() {
        setupAllSongs()
        setupFilteredSongs()
        setupOtherSongs()
        setupHoloMeberSongs()
        setupArtistSongs()
        setupMyFavoriteSongs()
        setupPlayListSongs()
        resetDisplaySongs()
        
        checkIdForDebug() // debug
    }
    
    private func setupAllSongs() {
        self.allSongs = JSONFileManager.getSongs(forResource: "suisei_songs")
        
        sortAllSongs()
        setFavoriteAllSongs()
    }
    
    private func sortAllSongs() {
        // 登校日が同じ場合に同じ動画が繋がるよう修正
        allSongs.sort { Double($0.date*10000)-Double($0.starttime) > Double($1.date*10000)-Double($1.starttime) }
    }
    
    private func setupFilteredSongs() {
        // TODO: オプションで変更できるようにしておく
        removeAcappella(enable: Settings.shared.filteredAcappella)
        removeNotSuisei(enable: true)
        removeDuplication(enable: Settings.shared.filteredDuplication)
        filteredSongs = allSongs.filter { !$0.filter }
    }
    
    // 重複する動画を削除
    // ただし、コラボとライブは対象から除外
    private func removeDuplication(enable: Bool) {
        var songTitles: [String] = []
        for song in allSongs {
            if song.members.count == 1 && !song.live3d && song.stream && !song.filter && songTitles.contains(song.songname) {
                song.filter = enable
            } else if song.members.count == 1 && !song.live3d && song.stream && !song.filter {
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
        notStreamSongs = filteredSongs.filter { !$0.stream }
        live3DSongs = filteredSongs.filter { $0.live3d }
        // お気に入りと履歴をセット
        favoriteSongs = allSongs.filter {
            Favorites.shared.favoriteIds.contains($0.id)
        }
        historySongs = allSongs.filter {
            Histories.shared.historyIds.contains($0.id)
        }
        sortOtherSongs()
        sortFavoriteAndHistory()
    }
    
    // reload時に呼び出すためpublicにする
    func sortOtherSongs() {
        // 表示順のIDを返す仕様とする
        // recommendから任意のIDを返せるようにする
        let notStreamIds = Recommend.randomize(songs: notStreamSongs)
        notStreamSongs = sorted(byIds: notStreamIds)
        let live3DIds = Recommend.randomize(songs: live3DSongs)
        live3DSongs = sorted(byIds: live3DIds)
    }

    func sortFavoriteAndHistory() {
        // 履歴とお気に入りは追加順で固定
        favoriteSongs = sorted(byIds: Favorites.shared.favoriteIds.reversed())
        historySongs = sorted(byIds: Histories.shared.historyIds.reversed())
    }

    
    private func sorted(byIds: [Int]) -> [Song] {
        return byIds.map { getSong(byId: $0) }
    }
    
    private func setupHoloMeberSongs() {
        var holoMembers_: [String] = []
        for song in filteredSongs {
            for member in song.members {
                if member != "星街すいせい" {
                    holoMembers_.append(member)
                }
            }
        }
        holoMembers = holoMembers_.uniqueSortedByCount().prefix(10).map { $0 }
        
        for holoMember in holoMembers {
            holoMembersSongs[holoMember] = filteredSongs.filter {
                $0.members.contains(holoMember)
            }
        }
    }
    
    private func setupArtistSongs() {
        var artists_: [String] = []
        for song in filteredSongs {
            artists_.append(song.artistname)
        }
        artists = artists_.uniqueSortedByCount().prefix(10).map { $0 }
        
        for artist in artists {
            artistsSongs[artist] = filteredSongs.filter {
                $0.artistname == artist
            }
        }
    }
    
    private func setupMyFavoriteSongs() {
        var myFavorites_: [String] = []
        for song in allSongs {
            if song.listtype != "None" {
                myFavorites_.append(song.listtype)
            }
        }
        myFavorites = myFavorites_.uniqueSortedByName()
        
        myFavoriteSongs = [:]
        for myFavorite in myFavorites {
            myFavoriteSongs[myFavorite] = allSongs.filter {
                $0.listtype == myFavorite
            }
        }
    }
    
    private func setupPlayListSongs() {
        playList = []
        for (key, _) in PlayLists.shared.playListIds {
            playList.append(key)
        }
        
        playListSongs = [:]
        for title in playList {
            if let playListIds = PlayLists.shared.playListIds[title] {
                playListSongs[title] = allSongs.filter {
                    playListIds.contains($0.id)
                }
            }
        }
        Logger.log(message: "ids: \(PlayLists.shared.playListIds)")
        Logger.log(message: "songs: \(playListSongs)")
    }
    
    func resetPlayListSongs() {
        setupPlayListSongs()
    }
    
    func resetDisplaySongs() {
        self.displaySongs = self.filteredSongs
    }
    
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
        var displaySongs_ = self.displaySongs.shuffled()
        if let selectedSong = SelectedStatus.shared.song {
            displaySongs_.removeAll(where: {$0 == selectedSong})
            displaySongs_.insert(selectedSong, at: 0)
        } else {
            Logger.log(message: "selectedSongが存在しません")
        }
        self.displaySongs = displaySongs_
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
