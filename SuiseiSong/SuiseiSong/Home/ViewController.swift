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
    
    // Button
    @IBOutlet weak var prevSongButton: UIButton!
    @IBOutlet weak var backwordButton: UIButton!
    @IBOutlet weak var playAndStopButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var nextSongButton: UIButton!
    
    // selectedSongが変更されたら変えたいのだがやり方が分からん
    @IBOutlet weak var playingSongLabel: UILabel!
    @IBOutlet weak var playingTimeLabel: UILabel!
    
    @IBOutlet weak var playingSlider: UISlider!
    
    private var songs: [Song] = []
    // songsを作り直してreloadする機能が欲しい、とりあえずこれをするために画面をいくつかに分割するUIでやってみる
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // JSONから取得
        // TODO: データベースからの取得に置き換え
        songs = GetSongFromJson.getSongs()
        
        // これを元にtableViewを作成
        songTableView.delegate = self
        songTableView.dataSource = self
        
        // playerのdelegateをセット
        playerView.delegate = self
        
        // Buttonの絵柄をセット
        prevSongButton.setImage(UIImage(systemName: "backward.end.fill"), for: .normal)
        backwordButton.setImage(UIImage(systemName: "backward.fill"), for: .normal)
        playAndStopButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        forwardButton.setImage(UIImage(systemName: "forward.fill"), for: .normal)
        nextSongButton.setImage(UIImage(systemName: "forward.end.fill"), for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(setPlayingSongLabel), name: Notification.Name("didChangedSelectedSong"), object: nil)
        
        // sharedにセット
        YTPlayerViewWrapper.shared.playerView = playerView
        YTPlayerViewWrapper.shared.setSelectedIdAndSong(selectedId: 0,
                                                        selectedSong: songs.first!)
    }
    
    // notificationの際にlabelを修正する
    @objc func setPlayingSongLabel() {
        playingSongLabel.text = YTPlayerViewWrapper.shared.selectedSong?.songtitle
    }
    
    
    // またシークバーを使って今の動画の調整をしたい
    // 直接シークバーを弄らないように独自のシークバーをつくる必要があるのか、難しい
    // playerのプロパティから取れない気がするので経過時間で頑張るしかないか
    // Delegateの中で1秒経過ごとに動かすとかかな？
    
    // selectedを監視して再生中のラベルを変化させる
    // NSNotification以外にないのか
    
    // 終了時にも利用するためメソッド化
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
    private func getImageByVideoId(videoId: String) -> UIImage{
        let urlWithVideoId = "https://i.ytimg.com/vi/\(videoId)/hqdefault.jpg"
        let url = URL(string: urlWithVideoId)
        do {
            let data = try Data(contentsOf: url!)
            return UIImage(data: data)!
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        return UIImage(systemName: "xmark.circle.fill")!
    }
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
        let song = songs[indexPath.row]
        cell.icon.image = getImageByVideoId(videoId: song.videoid)
        // 角を丸くする
        cell.icon.layer.cornerRadius = cell.icon.frame.size.width * 0.05
        cell.icon.clipsToBounds = true
        
        // cell.icon.image = UIImage(systemName: "face.smiling.fill")
        // セルに対応する歌をセット
        cell.song = song
        
        return cell
    }
}
