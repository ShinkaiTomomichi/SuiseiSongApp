//
//  ViewController.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/11.
//

import UIKit
import YouTubeiOSPlayerHelper

class ViewController: UIViewController {

    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var songTableView: UITableView!
    @IBOutlet weak var playAndStopButton: UIButton!
    // selectedSongが変更されたら変えたいのだがやり方が分からん
    @IBOutlet weak var playingSongLabel: UILabel!
    @IBOutlet weak var playingSlider: UISlider!
    
    private var songs: [Song] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // JSONから取得
        // TODO: データベースからの取得に置き換え
        songs = GetSongFromJson.getSongs()
        
        // これを元にtableViewを作成
        songTableView.delegate = self
        songTableView.dataSource = self
        
        playerView.delegate = self
        
        // sharedにセット
        YTPlayerViewWrapper.shared.playerView = playerView
        YTPlayerViewWrapper.shared.setSelectedIdAndSong(selectedId: 0,
                                                        selectedSong: songs.first!)
        
        // NotificationCenter.default.addObserver(<#T##observer: Any##Any#>, selector: <#T##Selector#>, name: <#T##NSNotification.Name?#>, object: <#T##Any?#>)
    }
    
    // notificationの際にlabelを修正する
    
    // またシークバーを使って今の動画の調整をしたい
    // 直接シークバーを弄らないように独自のシークバーをつくる必要があるのか、難しい
    // playerのプロパティから取れない気がするので経過時間で頑張るしかないか
    // Delegateの中で1秒経過ごとに動かすとかかな？
    
    // selectedを監視して再生中のラベルを変化させる
    // NSNotification以外にないのか
    
    // 終了時にも利用するためメソッド化
    // こことシークバーを足したら次はUIをマシにしていく
    func goToOtherSong (toIndexFromCurrent: Int) {
        print("debug: 次の動画へ進みます")
        if let currentSelectedId = YTPlayerViewWrapper.shared.selectedId {
            var nextSelectedId = currentSelectedId + toIndexFromCurrent
            if nextSelectedId < 0 {
                nextSelectedId = 0
            } else if nextSelectedId >= songs.count {
                nextSelectedId = songs.count - 1
            }
            YTPlayerViewWrapper.shared.setSelectedIdAndSong(selectedId: nextSelectedId,
                                                            selectedSong: songs[nextSelectedId])
        }
    }
        
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
            playAndStopButton.setTitle("▶︎", for: .normal)
        } else {
            self.playerView.playVideo()
            playAndStopButton.setTitle("■", for: .normal)
        }
    }
    
    @IBAction func tapForwardButton(_ sender: Any) {
        YTPlayerViewWrapper.shared.seek(toSeconds: 10)
    }
    
    @IBAction func tapNextSongButton(_ sender: Any) {
        goToOtherSong(toIndexFromCurrent: 1)
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
    
    // 値が変化した時
    @IBAction func changeSliderValue(_ sender: Any) {
        let slider = (sender as! UISlider)
        // print(slider.value)
    }
    
    // スライダーを触った時
    @IBAction func touchDownSlider(_ sender: Any) {
        YTPlayerViewWrapper.shared.playerView?.pauseVideo()
    }
    
    @IBAction func touchUpInsideSlider(_ sender: Any) {
        let slider = (sender as! UISlider)
        let currentTime = calcSliderTime(currentRate: slider.value)
        print(slider.value, currentTime)
        YTPlayerViewWrapper.shared.seek(toSeconds: currentTime,
                                        fromCurrent: false)
        YTPlayerViewWrapper.shared.playerView?.playVideo()
    }
    
    // stackの上詰めのやり方だけ覚えておきたい
    // tableviewを使ってリストを作ろう
    
    // 下のバーに色々用意しておきたい
    // 検索とお気に入りなどか、その場合テーブルビューの表示部分はモジュール化したいのだけどどうすればいいんだろう。ViewControllerを引数入れてモジュール化とかだろうか？
    // あー検索以外にも歌と他枠とかのフィルタも欲しい（これはバーじゃなくてフィルタリングで実現したい）
    
    // Youtubeの高さって可変にするのどうするんだろう
    // 取得時の高さ情報に応じてdelegateで動かすとかかね？
    // その場合TableViewがクソ小さくなってしまう
    
    // ちょっとデータベースのレパートリーを拡張しないと苦しい
    // あとは終了時の判定をどうするか?
    
    // 一旦ここの整理が完了したらDBの拡充をやる
    
    // 最初触るとなんでベノムに飛ぶんだ???
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(songs.count)
        return songs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: SongTableCell = tableView.dequeueReusableCell(withIdentifier: "SongTableCell", for: indexPath) as! SongTableCell
        // セルに表示する画像を仮で設定する
        cell.icon.image = UIImage(systemName: "face.smiling.fill")
        // セルに対応する歌をセット
        cell.song = songs[indexPath.row]
        
        return cell
    }
}
