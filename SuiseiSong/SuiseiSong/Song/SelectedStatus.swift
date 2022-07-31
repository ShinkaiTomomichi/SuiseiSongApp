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
    private(set) var id: Int? = nil
    
    // 最初にここを選択した後にfilteredを更新する処理を入れたい
    private(set) var song: Song? = nil {
        didSet {
            NotificationCenter.default.post(name: .didChangedSelectedSong, object: nil)
            // videoIDが異なるかを確認する
            YTPlayerViewWrapper.shared.shouldReload = oldValue?.videoid != song?.videoid
            // 動画を再生する
            // 画面に表示されている場合はreloadする
            if YTPlayerViewWrapper.shared.playerView != nil {
                YTPlayerViewWrapper.shared.start()
            }
        }
    }
    
    // 選択された曲が変化した場合に呼ばれる
    
    // songIDで選択する
    func setSelectedID(id: Int, filterCompletion: (() -> Void)? = nil) {
        self.song = Songs.shared.get(byID: id)
        
        // 選択後にIDを指定するためfilteringを実施（これはもっといい方法がありそう）
        if let filterCompletion = filterCompletion {
            filterCompletion()
        }
        
        // ここのID取得がどうなっているか
        
        self.id = Songs.shared.getFilteredID(bySong: self.song!)
    }
    
    func setSelectedSong(song: Song) {
        setSelectedID(id: song.id)
    }
    
    // reset(viewDidDisAppearなどで呼び出さないと問題が起こる)
    func reset() {
        self.song = nil
        self.id = nil
    }
    
    // TODO: Boolだとなんだかよく分からないのでResult型などに置き換える
    // IDを加算するだけではstartが走らないようになった
    func selectNextID() -> Bool {
        guard let id = self.id else {
            return false
        }
        
        if id + 1 < Songs.shared.filteredSongs.count {
            setSelectedSong(song: Songs.shared.filteredSongs[id+1])
            return true
        } else if Settings.shared.shouldRepeat {
            self.id! = 0
            return true
        } else {
            return false
        }
    }
    
    func selectPrevID() -> Bool {
        guard let id = self.id else {
            return false
        }
        
        if id > 0 {
            setSelectedSong(song: Songs.shared.filteredSongs[id-1])
            return true
        } else if Settings.shared.shouldRepeat {
            self.id! = Songs.shared.filteredSongs.count - 1
            return true
        } else {
            return false
        }
    }
}
