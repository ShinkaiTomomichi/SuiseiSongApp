//
//  YTPlayerView+.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/18.
//

import UIKit
import YouTubeiOSPlayerHelper

final class YTPlayerViewWrapper {
    static let shared = YTPlayerViewWrapper()
    private init() {}
    
    var playerView: YTPlayerView?
        
    var shouldReload: Bool = true
    var playing: Bool = false
    
    // autoplayが反応しない...Delegateの方で実装するしかないか?
    // 基本的に制御が増えると面倒なので一旦制御は外しておく
    func start() {
        if let selectedSong = SelectedStatus.shared.song {
            if shouldReload {
                let playerVars = [
                    "controls": 0,
                    "start": Float(selectedSong.starttime)
                ]
                self.playerView?.load(withVideoId: selectedSong.videoid,
                                          playerVars: playerVars)
            } else {
                // videoIdが同じ場合seekのみにしておく
                self.playerView?.seek(toSeconds: Float(selectedSong.starttime),
                                      allowSeekAhead: true)
            }
        }
    }
    
    func seek(toSeconds: Float, fromCurrent: Bool = true) {
        // TODO: fromCurrent=falseの場合に不要な処理が入っているため除く
        var timeAfterSeek = toSeconds
        self.playerView?.currentTime({ result, error in
            if fromCurrent {
                timeAfterSeek = result + toSeconds
            }
            if let selectedSong = SelectedStatus.shared.song {
                if timeAfterSeek > Float(selectedSong.endtime) {
                    timeAfterSeek = Float(selectedSong.endtime)
                } else if timeAfterSeek < Float(selectedSong.starttime) {
                    timeAfterSeek = Float(selectedSong.starttime)
                }
                self.playerView?.seek(toSeconds: timeAfterSeek, allowSeekAhead: true)
            }
        })
    }
    
}
