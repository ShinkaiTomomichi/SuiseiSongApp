//
//  ViewController.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/11.
//

import UIKit
import YouTubeiOSPlayerHelper

class ViewController: UIViewController {
    
    // PlayerもVCに直書きじゃない方が良いか？
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var songTableView: UITableView!
    
    // Button
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var prevSongButton: UIButton!
    @IBOutlet weak var backwordButton: UIButton!
    @IBOutlet weak var playAndStopButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var nextSongButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!
    
    // selectedSongが変更されたら変えたいのだがやり方が分からん
    @IBOutlet weak var playingSongLabel: UILabel!
    @IBOutlet weak var playingTimeLabel: UILabel!
    
    @IBOutlet weak var playingSlider: UISlider!
    
    // とりあえずcollectionを追加してジャンルの追加を試みる
    // その前にジャンル分けとデータセット作成の方をやっておこうかね
    // サイエンス周りは脳死でやれるので夜にやる
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // これを元にtableViewを作成
        songTableView.delegate = self
        songTableView.dataSource = self
        
        // playerのdelegateをセット
        playerView.delegate = self
        
        // Buttonの絵柄をセット
        searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        settingButton.setImage(UIImage(systemName: "gearshape.fill"), for: .normal)
        
        prevSongButton.setImage(UIImage(systemName: "backward.end.fill"), for: .normal)
        backwordButton.setImage(UIImage(systemName: "gobackward.10"), for: .normal)
        playAndStopButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        forwardButton.setImage(UIImage(systemName: "goforward.10"), for: .normal)
        nextSongButton.setImage(UIImage(systemName: "forward.end.fill"), for: .normal)
        
        shuffleButton.setImage(UIImage(systemName: "shuffle"), for: .normal)
        repeatButton.setImage(UIImage(systemName: "repeat"), for: .normal)
        
        // selectorがlabelに紐づいているのでVCで立てているが重複するケースはないか？
        NotificationCenter.default.addObserver(self, selector: #selector(setPlayingSongLabel), name: .didChangedSelectedSong, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: .didChangedFilteredSong, object: nil)
        
        // sharedにセット
        YTPlayerViewWrapper.shared.playerView = playerView
        YTPlayerViewWrapper.shared.setSelectedIdAndSong(selectedId: 0,
                                                        selectedSong: Songs.shared.filteredSongs.first!)
    }
    
    // 再生した曲が変化した際にlabelを修正する
    @objc func setPlayingSongLabel() {
        playingSongLabel.text = YTPlayerViewWrapper.shared.selectedSong?.songtitle
    }
    
    // filteredの中身が変化したらtableViewをリロードするメソッドが欲しい
    @objc func reloadTableView() {
        songTableView.reloadData()
    }
    
    // 終了時にも利用するためメソッド化
    // selectedSongに混ぜ込む
    func goToOtherSong (toIndexFromCurrent: Int) {
        if let currentSelectedId = YTPlayerViewWrapper.shared.selectedId {
            var nextSelectedId = currentSelectedId + toIndexFromCurrent
            if nextSelectedId < 0 {
                nextSelectedId = 0
            } else if nextSelectedId >= Songs.shared.filteredSongs.count {
                nextSelectedId = Songs.shared.filteredSongs.count - 1
            }
            YTPlayerViewWrapper.shared.setSelectedIdAndSong(selectedId: nextSelectedId,
                                                            selectedSong: Songs.shared.filteredSongs[nextSelectedId])
        }
    }
    
    // Buttonの塊は一つのモジュールに入れておきたい
    // StackViewのクラスを別で切り出した方がいいか？
    @IBAction func tapPrevSongButton(_ sender: Any) {
        // TODO: pause中や再生中にスライダーの変化が遅れるのを修正
        goToOtherSong(toIndexFromCurrent: -1)
    }
    
    @IBAction func tapBackwordButton(_ sender: Any) {
        YTPlayerViewWrapper.shared.seek(toSeconds: -10)
    }
    
    @IBAction func tapPlayAndStopButton(_ sender: Any) {
        if YTPlayerViewWrapper.shared.playing {
            self.playerView.pauseVideo()
        } else {
            self.playerView.playVideo()
        }
    }
    
    @IBAction func tapForwardButton(_ sender: Any) {
        YTPlayerViewWrapper.shared.seek(toSeconds: 10)
    }
    
    @IBAction func tapNextSongButton(_ sender: Any) {
        goToOtherSong(toIndexFromCurrent: 1)
    }
    
    @IBAction func tapShuffleButton(_ sender: Any) {
        Songs.shared.shuffle()
        // これシャッフルではなくて、filteredが変更した時にやりたい
        YTPlayerViewWrapper.shared.setSelectedIdAndSong(selectedId: 0,
                                                        selectedSong: Songs.shared.filteredSongs.first!)
    }
    
    @IBAction func tapRepeatButton(_ sender: Any) {
        // settingのsharedを用意すべきか
        // それともこの画面限定の機能にするか？
    }
    
    @IBAction func tapSearchButton(_ sender: Any) {
        // tap用のモーダルが出るようにしたいが、一旦簡略化
        Songs.shared.filter(by: "覚醒")
        
        // 簡単なViewなら呼べるがどうするのがベストか...
    }
    
    // delegateにsliderやtableViewの値を参照するのはイマイチな気がするが...
    func calcSliderPosition(currentTime: Float) -> Float {
        if let starttime = YTPlayerViewWrapper.shared.selectedSong?.starttime, let endtime = YTPlayerViewWrapper.shared.selectedSong?.endtime {
            let elapsedTime = currentTime - Float(starttime)
            let allTime = Float(endtime) - Float(starttime)
            return elapsedTime / allTime
        }
        return 0
    }
    
    func calcSliderTime(currentRate: Float) -> Float {
        if let starttime = YTPlayerViewWrapper.shared.selectedSong?.starttime, let endtime = YTPlayerViewWrapper.shared.selectedSong?.endtime {
            let allTime = Float(endtime) - Float(starttime)
            let currentTime = Float(starttime) + currentRate * allTime
            return currentTime
        }
        return 0
    }
    
    func calcPlayingTime(currentTime: Float) -> String {
        if let starttime = YTPlayerViewWrapper.shared.selectedSong?.starttime, let endtime = YTPlayerViewWrapper.shared.selectedSong?.endtime {
            let elapsedTime = Int(currentTime) - starttime
            let elapsedTimeStr = elapsedTime.toTimeStamp()
            let allTime = Int(endtime) - starttime
            let allTimeStr = allTime.toTimeStamp()
            return "\(elapsedTimeStr)/\(allTimeStr)"
        }
        return "0:00/0:00"
    }
    
    // 値が変化した時
    @IBAction func changeSliderValue(_ sender: Any) {
        let _ = (sender as! UISlider)
        // print(slider.value)
    }
    
    // スライダーを触った時
    @IBAction func touchDownSlider(_ sender: Any) {
        YTPlayerViewWrapper.shared.playerView?.pauseVideo()
    }
    
    @IBAction func touchUpInsideSlider(_ sender: Any) {
        let slider = (sender as! UISlider)
        let currentTime = calcSliderTime(currentRate: slider.value)
        YTPlayerViewWrapper.shared.seek(toSeconds: currentTime,
                                        fromCurrent: false)
        YTPlayerViewWrapper.shared.playerView?.playVideo()
    }
    
    // Youtubeの高さって可変にするのどうするんだろう
    // 取得時の高さ情報に応じてdelegateで動かすとかかね？
    // その場合TableViewがクソ小さくなってしまう

}
