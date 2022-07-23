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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        YTPlayerViewWrapper.shared.playerView = playerView
        Songs.shared.setup()
        
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
                
        NotificationCenter.default.addObserver(self, selector: #selector(setPlayingSongLabel), name: .didChangedSelectedSong, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: .didChangedFilteredSong, object: nil)
    }
    
    // 再生した曲が変化した際にlabelを修正する
    @objc func setPlayingSongLabel() {
        playingSongLabel.text = SelectedStatus.shared.song?.songtitle
        // cancelHighlightingAllCell()
        // highlightSelectedCell()
    }
    
    // TODO: メモリから外されたセルの状態を管理するのがかなり難しい、、、一旦保留
    /*
    private func cancelHighlightingAllCell() {
        for i in 0..<songTableView.visibleCells.count{
            let indexPath = IndexPath(row: i, section: 0)
            let cell = songTableView.cellForRow(at: indexPath) as! SongTableCell
            cell.selectedView.alpha = 0
        }
    }
    
    private func highlightSelectedCell() {
        let indexPath = IndexPath(row: SelectedStatus.shared.id!, section: 0)
        Logger.log(message: indexPath)
        let cell = songTableView.cellForRow(at: indexPath) as! SongTableCell
        cell.selectedView.alpha = 0.1
    }
    */
    
    // filteredの中身が変化したらtableViewをリロードするメソッドが欲しい
    @objc func reloadTableView() {
        songTableView.reloadData()
    }
    
    // Buttonの塊は一つのモジュールに入れておきたい
    @IBAction func tapPrevSongButton(_ sender: Any) {
        SelectedStatus.shared.selectPrevID()
    }
    
    @IBAction func tapBackwordButton(_ sender: Any) {
        // TODO: pause中や再生中にスライダーの変化が遅れるのを修正
        // 移動時に全て反映させるのはYTPlayerのDelegateで管理したい
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
        SelectedStatus.shared.selectNextID()
    }
    
    @IBAction func tapShuffleButton(_ sender: Any) {
        Songs.shared.shuffle()
    }
    
    @IBAction func tapRepeatButton(_ sender: Any) {
        Settings.shared.shouldRepeat.toggle()
    }
    
    @IBAction func tapSearchButton(_ sender: Any) {
        // tap用のモーダルが出るようにしたいが、一旦簡略化
        // 明日以降はViewを呼ぶ処理とHomeまで戻ってくる処理を追加したい
        // フィルタ内容が反映できればだいぶ上々
        Songs.shared.filter(by: "覚醒")
        
        // 検索ログは見る必要はあまりないが、、、
        // もしかしたらこの辺ってFirebaseとかで見れるのか？？？
    }
    
    // delegateにsliderやtableViewの値を参照するのはイマイチな気がするが...
    func calcSliderPosition(currentTime: Float) -> Float {
        if let starttime = SelectedStatus.shared.song?.starttime, let endtime = SelectedStatus.shared.song?.endtime {
            let elapsedTime = currentTime - Float(starttime)
            let allTime = Float(endtime) - Float(starttime)
            return elapsedTime / allTime
        }
        return 0
    }
    
    func calcSliderTime(currentRate: Float) -> Float {
        if let starttime = SelectedStatus.shared.song?.starttime, let endtime = SelectedStatus.shared.song?.endtime {
            let allTime = Float(endtime) - Float(starttime)
            let currentTime = Float(starttime) + currentRate * allTime
            return currentTime
        }
        return 0
    }
    
    func calcPlayingTime(currentTime: Float) -> String {
        if let starttime = SelectedStatus.shared.song?.starttime, let endtime = SelectedStatus.shared.song?.endtime {
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
    
    // Playerの大きさを可変にしたいな...動画の方でAPI経由でとったほうが楽かも
    // selectedの管理がクソだった... 治さねば...
    // 色はとりあえず黒ベースにしてもいいかも
}
