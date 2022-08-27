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
    
    @IBOutlet weak var lockView: UIView!
    @IBOutlet weak var hiddenView: UIView!
    @IBOutlet weak var releaseButton: UIButton!
    @IBOutlet weak var releaseLabel: UILabel!
    
    // NavigationBarに追加するボタン
    var shareBarButtonItem: UIBarButtonItem!
    var lockBarButtonItem: UIBarButtonItem!
    
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
        prevSongButton.setImage(UIImage.initWithTintColorWhite(systemName: "backward.end.fill"), for: .normal)
        backwordButton.setImage(UIImage.initWithTintColorWhite(systemName:  "gobackward.10"), for: .normal)
        setPlayAndStopButton()
        forwardButton.setImage(UIImage.initWithTintColorWhite(systemName: "goforward.10"), for: .normal)
        nextSongButton.setImage(UIImage.initWithTintColorWhite(systemName: "forward.end.fill"), for: .normal)
        
        shuffleButton.setImage(UIImage.initWithTintColorWhite(systemName: "shuffle"), for: .normal)
        reloadRepeatTypeButton()
        setPlayingSongLabel()
                
        shareBarButtonItem = UIBarButtonItem(image: UIImage.initWithTintColorWhite(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareBarButtonTapped(_:)))
        lockBarButtonItem = UIBarButtonItem(image: UIImage.initWithTintColorWhite(systemName: "lock"), style: .plain, target: self, action: #selector(lockBarButtonTapped(_:)))
        
        lockView(true)
        // 長押しアクションを登録する
        // TODO: 長押しよりも解除しにくいアクションに変更する
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress))
        releaseButton.addGestureRecognizer(recognizer)
        // ボタンの大きさ変更
        releaseButton.imageView?.contentMode = .scaleAspectFill
        releaseButton.contentHorizontalAlignment = .fill
        releaseButton.contentVerticalAlignment = .fill
        // ボタンタイプをCustomにする必要がある        
        releaseButton.setImage(UIImage(named: "suisei_lock.png"), for: .normal)
        
        self.navigationItem.rightBarButtonItems = [shareBarButtonItem, lockBarButtonItem]
                
        // Notificationをset
        NotificationCenter.default.addObserver(self, selector: #selector(setPlayingSongLabel), name: .didChangedSelectedSong, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setPlayAndStopButton), name: .didChangedPlaying, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(reloadRepeatTypeButton), name: .didChangedRepeatType, object: nil)
        
        setupBackground()
    }
    
    private func setupBackground() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
    }
    
    // 再度復帰した際に画面が表示されなくなる不具合がある
    // TODO: そもそもこれ必要なのか検討
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
        // shareText += "#星街すいせい" // 各配信のハッシュタグを添えられると良さそう、配信者名でいいか？
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
    
    // 再生した曲が変化した際にlabelを修正する
    @objc func setPlayingSongLabel() {
        playingSongLabel.text = SelectedStatus.shared.song?.songtitle
        songTableView.reloadData()
    }
    
    @objc func setPlayAndStopButton() {
        if YTPlayerViewWrapper.shared.playing {
            playAndStopButton.setImage(UIImage.initWithTintColorWhite(systemName: "pause.fill"), for: .normal)
        } else {
            playAndStopButton.setImage(UIImage.initWithTintColorWhite(systemName: "play.fill"), for: .normal)
        }
    }
    
    @objc func reloadRepeatTypeButton() {
        if Settings.shared.repeatType == .none {
            repeatButton.setImage(UIImage.initWithTintColorWhite(systemName: "repeat.circle"), for: .normal)
        } else if Settings.shared.repeatType == .allRepeat {
            repeatButton.setImage(UIImage.initWithTintColorWhite(systemName: "repeat.circle.fill"), for: .normal)
        } else {
            repeatButton.setImage(UIImage.initWithTintColorWhite(systemName: "repeat.1.circle.fill"), for: .normal)
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
        Songs.shared.shuffleDisplaySongsExpectSelectedSong()
        // TODO: ここでTableViewのスクロールが実行されない
        songTableView.setContentOffset(.zero, animated: false)
        // songTableView.reloadData()
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
    
    @objc func lockBarButtonTapped(_ sender: UIBarButtonItem) {
        lockView(false)
    }
        
    @objc func onLongPress() {
        lockView(true)
    }
    
    private func lockView(_ state: Bool) {
        // lockViewの表示を切り替える
        lockView.isHidden = state
        hiddenView.isHidden = state
        releaseButton.isHidden = state
        releaseLabel.isHidden = state
        
        // BarButtonを切り替える
        lockBarButtonItem.isEnabled = state
        shareBarButtonItem.isEnabled = state
        navigationItem.hidesBackButton = !state
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
