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
    
    // Idの管理外したい...なんとかならんのか
    // IdとSongを管理するクラスに分けるか
    // Idじゃなくてnextとprevとか持っておくと良いのかな？
    private(set) var selectedId: Int?
    private(set) var selectedSong: Song? {
        didSet {
            Logger.log(message: selectedSong!.songtitle)
            shouldReload = oldValue?.videoid != selectedSong?.videoid
            NotificationCenter.default.post(name: .didChangedSelectedSong, object: nil)
        }
    }
    
    private var shouldReload: Bool = false
    var playing: Bool = false
    
    // selectedIdとselectedSongは同時に決定する
    func setSelectedIdAndSong (selectedId: Int, selectedSong: Song, withStart: Bool = true) {
        self.selectedId = selectedId
        self.selectedSong = selectedSong
        if withStart {
            self.start()
        }
    }
    
    // autoplayが反応しない...Delegateの方で実装するしかないか?
    // 基本的に制御が増えると面倒なので一旦制御は外しておく
    func start() {
        if let selectedSong = self.selectedSong {
            if shouldReload {
                let playerVars = [
                    "controls": 0,
                    "start": Float(selectedSong.starttime)
                ]
                self.playerView?.load(withVideoId: selectedSong.videoid,
                                      playerVars: playerVars)
                // load中だと再生されない?
                // ていうかこれいるか？
                self.playerView?.playVideo()
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
            if let selectedSong = self.selectedSong {
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
