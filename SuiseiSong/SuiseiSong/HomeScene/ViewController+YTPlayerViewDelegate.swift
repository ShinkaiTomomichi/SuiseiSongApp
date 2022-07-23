//
//  ViewController+.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/18.
//

import UIKit
import YouTubeiOSPlayerHelper

extension ViewController: YTPlayerViewDelegate {
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
        if let endtime = YTPlayerViewWrapper.shared.selectedSong?.endtime {
            if playTime >= Float(endtime) {
                print("ここに次の動画へ進む処理を挟みたい")
                goToOtherSong(toIndexFromCurrent: 1)
            }
        }
    }
    
    // 次の動画に進む時に必要だが、初回から起動されるとやや困る
    // 初回起動のフラグを管理しておきたい
    // 画面リセットの際にも起動して欲しくないのでこれの改善も測る
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        if FirstLAunchFlag.shared.isFirstLaunch {
            FirstLAunchFlag.shared.isFirstLaunch = false
        } else {
            playerView.playVideo()
        }
    }
}
