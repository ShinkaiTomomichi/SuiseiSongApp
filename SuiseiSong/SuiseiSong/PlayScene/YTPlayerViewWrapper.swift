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
    var playing: Bool = false {
        didSet {
            NotificationCenter.default.post(name: .didChangedPlaying, object: nil)
        }
    }
    
    // TODO: ここで履歴情報を追加する
    // 履歴情報は別途で動画譲歩も必要なので面倒かも
    func start() {
        if let selectedSong = SelectedStatus.shared.song {
            // 選択されていない時の処理を明確にする
            // 画面のloadをやり直して適当な画像を差し込む
            if let isHidden = playerView?.isHidden, isHidden {
                playerView?.isHidden = false
            }
            
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
        } else {
            Logger.log(message: "selectedSongが設定されていません")
            playerView?.pauseVideo()
            playerView?.isHidden = true
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
