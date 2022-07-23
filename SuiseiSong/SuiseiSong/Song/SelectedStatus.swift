//
//  selectedSong.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/23.
//

import Foundation

final class SelectedStatus {
    static var shared = SelectedStatus()
    private init() {}

    // 範囲外を指定できないようにprivateにしておく
    private(set) var id: Int? = nil {
        didSet {
            if let id = id {
                self.song = Songs.shared.filteredSongs[id]
            }
        }
    }
    
    // 最初のコンストラクタで呼ばれて、load中にseekを叩いているのがまずいかも
    var song: Song? = nil {
        didSet {
            NotificationCenter.default.post(name: .didChangedSelectedSong, object: nil)
            // videoIDが異なるかを確認する
            YTPlayerViewWrapper.shared.shouldReload = oldValue?.videoid != song?.videoid
            // 動画を再生する
            YTPlayerViewWrapper.shared.start()
        }
    }
    
    // 選択された曲が変化した場合に呼ばれる
    // TODO: idが負の数で渡された場合nilを返すが、なんらかのerrorを返すのか望ましい
    func setSelectedID(id: Int = 0) {
        if id < 0 {
            self.id = nil
            return
        }
        self.id = Songs.shared.filteredSongs.count > id ? id : nil
    }
    
    func selectNextID() {
        if let id = self.id, id + 1 < Songs.shared.filteredSongs.count {
            self.id! += 1
        } else if Settings.shared.shouldRepeat {
            self.id! = 0
        }
    }
    
    func selectPrevID() {
        if let id = self.id, id > 0 {
            self.id! -= 1
        } else if Settings.shared.shouldRepeat {
            self.id! = Songs.shared.filteredSongs.count - 1
        }
    }
}
