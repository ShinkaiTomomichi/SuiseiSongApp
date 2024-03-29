//
//  ViewController+.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/18.
//

import UIKit
import YouTubeiOSPlayerHelper

extension PlayViewController: YTPlayerViewDelegate {
    // stateが変化した時に呼ばれるdelegate
    // sliderはこれの変化によって変化してもいいかも
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch (state) {
        case YTPlayerState.unstarted:
            YTPlayerViewWrapper.shared.playing = false
            Logger.log(message: "停止中")
        case YTPlayerState.playing:
            YTPlayerViewWrapper.shared.playing = true
            Logger.log(message: "再生中")
        case YTPlayerState.paused:
            YTPlayerViewWrapper.shared.playing = false
            Logger.log(message: "一時停止中")
        case YTPlayerState.buffering:
            Logger.log(message: "バッファリング中")
        case YTPlayerState.ended:
            YTPlayerViewWrapper.shared.playing = false
            // 動画終了時も次の動画に遷移するよう修正
            goToNextSong()
            Logger.log(message: "再生終了")
        default:
            break
        }
    }
    
    // 再生中に（0.5秒ごとに?）呼ばれるdelegate
    // 処理が多いので可能であれば分割したい
    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
        // print("didPlayTime", playTime)
        
        // スライダーの値に反映させる
        playingSlider.value = calcSliderPosition(currentTime: playTime)
        
        // テキストの値に反映させる
        playingTimeLabel.text = calcPlayingTime(currentTime: playTime)
        
        // 終了時刻を超えたら次の動画に進む
        // 次の動画に進めない場合は停止する
        if let endtime = SelectedStatus.shared.song?.endtime,
            playTime >= Float(endtime) {
            goToNextSong()
        }
    }
    
    private func goToNextSong() {
        // ここに次の動画へ進む処理を挟みたい
        // singleRepeatの場合は同じ動画へループする
        if Settings.shared.repeatType == .singleRepeat {
            // ここで再度選択する挙動を示さないと再リロードが入る
            YTPlayerViewWrapper.shared.start()
        } else {
            let goNextSuccessed = SelectedStatus.shared.selectNextID()
            if !goNextSuccessed {
                playerView.pauseVideo()
            }
        }
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
}
