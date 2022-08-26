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
            print("停止中")
        case YTPlayerState.playing:
            YTPlayerViewWrapper.shared.playing = true
            print("再生中")
        case YTPlayerState.paused:
            YTPlayerViewWrapper.shared.playing = false
            print("一時停止中")
        case YTPlayerState.buffering:
            print("バッファリング中")
        case YTPlayerState.ended:
            YTPlayerViewWrapper.shared.playing = false
            print("再生終了")
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
            endtimeExceed()
        }
    }
    
    private func endtimeExceed() {
        // ここに次の動画へ進む処理を挟みたい
        // singleRepeatの場合は同じ動画へループする
        // 現状shouldの挙動がおかしいため修正する
        if Settings.shared.repeatType == .singleRepeat {
            // ここで再度選択する挙動を示さないと再リロードが入る
            YTPlayerViewWrapper.shared.start()
        } else {
            let goNextSuccessed = SelectedStatus.shared.selectNextID()
            if !goNextSuccessed {
                playerView.pauseVideo()
                // TODO: 止めるだけではなく動画を動かなくする必要がある
            }
        }
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
}
