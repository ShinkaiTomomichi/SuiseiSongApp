//
//  ViewController.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/11.
//

import UIKit
import YouTubeiOSPlayerHelper

class PlayViewController: UIViewController {
    
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var songTableView: UITableView!
    
    // 動画再生に関するボタン
    @IBOutlet weak var playingSlider: UISlider!
    @IBOutlet weak var prevSongButton: UIButton!
    @IBOutlet weak var backwordButton: UIButton!
    @IBOutlet weak var playAndStopButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var nextSongButton: UIButton!
    
    // シャッフルとリピート
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!
    
    // 再生中の曲と時間を示すラベル
    @IBOutlet weak var playingSongLabel: UILabel!
    @IBOutlet weak var playingTimeLabel: UILabel!
    
    // NavigationBarに追加するボタン
    var shareBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        YTPlayerViewWrapper.shared.playerView = playerView
        YTPlayerViewWrapper.shared.start()
        
        // Delegateをセット
        songTableView.dataSource = self
        songTableView.delegate = self
        // xibファイルからUIコンポーネントを参照する際に必要
        songTableView.register(UINib(nibName: "SongTableViewCell", bundle: nil), forCellReuseIdentifier: "SongTableViewCell")
        playerView.delegate = self
        
        // Buttonの絵柄をセット
        // TODO: これだとアプリ起動中にダークモード切り替えが起きた場合に対応できない
        prevSongButton.setImage(UIImage.initWithDarkmode(systemName: "backward.end.fill"), for: .normal)
        backwordButton.setImage(UIImage.initWithDarkmode(systemName:  "gobackward.10"), for: .normal)
        setPlayAndStopButton()
        forwardButton.setImage(UIImage.initWithDarkmode(systemName: "goforward.10"), for: .normal)
        nextSongButton.setImage(UIImage.initWithDarkmode(systemName: "forward.end.fill"), for: .normal)
        
        shuffleButton.setImage(UIImage.initWithDarkmode(systemName: "shuffle"), for: .normal)
        reloadRepeatTypeButton()
        setPlayingSongLabel()
                
        shareBarButtonItem = UIBarButtonItem(image: UIImage.initWithDarkmode(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareBarButtonTapped(_:)))
        
        self.navigationItem.rightBarButtonItems = [shareBarButtonItem]
        
        playerView.frame = CGRect(x: 0 , y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.7)
        
        // Notificationをset
        NotificationCenter.default.addObserver(self, selector: #selector(setPlayingSongLabel), name: .didChangedSelectedSong, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setPlayAndStopButton), name: .didChangedPlaying, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: .didChangedFilteredSong, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadRepeatTypeButton), name: .didChangedRepeatType, object: nil)
    }
    
    // 再度復帰した際に画面が表示されなくなる不具合がある
    // 導線次第では修正したい
    override func viewDidDisappear(_ animated: Bool) {
        SelectedStatus.shared.reset()
    }
        
    @objc func shareBarButtonTapped(_ sender: UIBarButtonItem) {
        showShareSheet()
    }
    
    private func showShareSheet() {
        let selectedSong = SelectedStatus.shared.song
        var shareText = "\(selectedSong!.songtitle)を聴いてます。\n"
        shareText += "https://youtu.be/\(selectedSong!.videoid)?t=\(selectedSong!.starttime)\n"
        shareText += "(サンプル)" // 各配信のハッシュタグを添えられると良さそう、配信者名でいいか？
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
    
    // 再生した曲が変化した際にlabelを修正する
    @objc func setPlayingSongLabel() {
        playingSongLabel.text = SelectedStatus.shared.song?.songtitle
        // TODO: 選択中のラベルをハイライトしようとしたが、メモリから外れたセルを管理するのが困難であったため一旦保留
    }
    
    // filteredの中身が変化したらtableViewをリロードするメソッドが欲しい
    @objc func reloadTableView() {
        songTableView.reloadData()
    }
    
    @objc func setPlayAndStopButton() {
        if YTPlayerViewWrapper.shared.playing {
            playAndStopButton.setImage(UIImage.initWithDarkmode(systemName: "pause.fill"), for: .normal)
        } else {
            playAndStopButton.setImage(UIImage.initWithDarkmode(systemName: "play.fill"), for: .normal)
        }
    }
    
    @objc func reloadRepeatTypeButton() {
        if Settings.shared.repeatType == .none {
            repeatButton.setImage(UIImage.initWithDarkmode(systemName: "repeat.circle"), for: .normal)
        } else if Settings.shared.repeatType == .allRepeat {
            repeatButton.setImage(UIImage.initWithDarkmode(systemName: "repeat.circle.fill"), for: .normal)
        } else {
            repeatButton.setImage(UIImage.initWithDarkmode(systemName: "repeat.1.circle.fill"), for: .normal)
        }
    }
    
    // Buttonの塊は一つのモジュールに入れておきたい
    @IBAction func tapPrevSongButton(_ sender: Any) {
        let _ = SelectedStatus.shared.selectPrevID()
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
        let _ = SelectedStatus.shared.selectNextID()
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
    
    @IBAction func tapShuffleButton(_ sender: Any) {
        Songs.shared.shuffle()
    }
    
    @IBAction func tapRepeatButton(_ sender: Any) {
        Settings.shared.toggleRepeatType()
    }
    
    // delegateにsliderやtableViewの値を参照するのはイマイチな気がするが...
    // これもテストとかしておきたい
    // これとcellの部分はstoryboardごと分離したい
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
        return "ERROR"
    }
    
    // Youtubeの高さって可変にするのどうするんだろう
    // 取得時の高さ情報に応じてdelegateで動かすとかかね？
    // その場合TableViewがクソ小さくなってしまう
    
    // Playerの大きさを可変にしたいな...動画の方でAPI経由でとったほうが楽かも
    // 色はとりあえず黒ベースにしてもいいかも
    
    // ちょいちょいWebViewの挙動も変な時があるのは見直したい
    
    // searchBarも練習用に一度作っておきたいが、正直検索機能そこまで要らん気もする
    // UI的にはtabの方が良さそう
}
