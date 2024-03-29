//
//  selectedSong.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/23.
//

import Foundation

// filteredの中身が0の場合の挙動が決まっていない
final class SelectedStatus {
    static var shared = SelectedStatus()
    private init() {}

    // filtererの中の順番
    private(set) var filteredID: Int? = nil
    
    // 最初にここを選択した後にfilteredを更新する処理を入れたい
    private(set) var song: Song? = nil {
        didSet {
            if oldValue?.id != song?.id {
                NotificationCenter.default.post(name: .didChangedSelectedSong, object: nil)
            }
            // videoIDが異なるかを確認する
            YTPlayerViewWrapper.shared.shouldReload = oldValue?.videoid != song?.videoid
            // 動画を再生する
            // 画面に表示されている場合はreloadする
            if YTPlayerViewWrapper.shared.playerView != nil, oldValue?.id != song?.id {
                YTPlayerViewWrapper.shared.start()
            }
        }
    }
    
    // 選択された曲が変化した場合に呼ばれる
    // songIDで選択する
    func setSelectedID(id: Int, filterCompletion: (() -> Void)? = nil) {
        self.song = Songs.shared.getSong(byId: id)
        
        // 選択後にIDを指定するためfilteringを実施（これはもっといい方法がありそう）
        if let filterCompletion = filterCompletion {
            filterCompletion()
        }
        
        self.filteredID = Songs.shared.getFilteredId(bySong: self.song!)
    }
    
    // songで選択する
    func setSelectedSong(song: Song, filterCompletion: (() -> Void)? = nil) {
        setSelectedID(id: song.id, filterCompletion: filterCompletion)
    }
    
    // reset(viewDidDisAppearなどで呼び出さないと問題が起こる)
    func reset() {
        self.song = nil
        self.filteredID = nil
    }
    
    // TODO: Boolだとなんだかよく分からないのでResult型などに置き換える
    func selectNextID() -> Bool {
        guard let id = self.filteredID else {
            return false
        }
        
        if id + 1 < Songs.shared.displaySongs.count {
            setSelectedSong(song: Songs.shared.displaySongs[id+1])
            return true
        } else if Settings.shared.repeatType == .allRepeat {
            setSelectedSong(song: Songs.shared.displaySongs[0])
            return true
        } else {
            return false
        }
    }
    
    func selectPrevID() -> Bool {
        guard let id = self.filteredID else {
            return false
        }
        
        if id > 0 {
            setSelectedSong(song: Songs.shared.displaySongs[id-1])
            return true
        } else if Settings.shared.repeatType == .allRepeat {
            setSelectedSong(song: Songs.shared.displaySongs[Songs.shared.displaySongs.count - 1])
            return true
        } else {
            return false
        }
    }
}
