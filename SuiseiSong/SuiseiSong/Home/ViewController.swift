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
        
        
        self.playerView.load(withVideoId: "njGJGwx_eVM")
        
        // viewDidLoadだと多分追いつかない
        // self.playerView.playVideo()
        // self.playerView.pauseVideo()
        // self.playerView.stopVideo()
    }
    
    // とりあえずYoutubeを表示できるような面を作成
    // あーサインインとかが必要か？
    // 逆にそういうのが必要なければProjectは不要か？
    // 再生開始からn秒で発火するように拡張する必要がありそう
    
    // IFrameの埋め込みだけ作ってみるViewを作ってそれのDelegateを実装？
    // 任意のタイミングでloadし直す機能はどうするのがベストだろうか？
    // Swiftならcsvよりもjsonの方がさそう
    
    // あーシークバーから選択するようなメソッドもあるな、使ってみよう
    
    // stackの上詰めのやり方だけ覚えておきたい
    // tableviewを使ってリストを作ろう
    
    // 下のバーに色々用意しておきたい
    // 検索とお気に入りなどか、その場合テーブルビューの表示部分はモジュール化したいのだけどどうすればいいんだろう。ViewControllerを引数入れてモジュール化とかだろうか？
    // あー検索以外にも歌と他枠とかのフィルタも欲しい（これはバーじゃなくてフィルタリングで実現したい）
    
    // 直接シークバーを弄らないように独自のシークバーをつくる必要があるのか、難しい
    // playerのプロパティから取れない気がするので経過時間で頑張るしかないか
    // Delegateの中で1秒経過ごとに動かすとかかな？
    
    // Youtubeの高さって可変にするのどうするんだろう
    // 取得時の高さ情報に応じてdelegateで動かすとかかね？
    // その場合TableViewがクソ小さくなってしまう
}

extension ViewController: YTPlayerViewDelegate {
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        switch (state) {
        case YTPlayerState.unstarted:
            print("停止中")
        case YTPlayerState.playing:
            print("再生中")
        case YTPlayerState.paused:
            print("一時停止中")
        case YTPlayerState.buffering:
            print("バッファリング中")
        case YTPlayerState.ended:
            print("再生終了")
        default:
            break
        }
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
        // セルに表示する値を設定する
        
        cell.icon.image = UIImage(systemName: "face.smiling.fill")
        cell.title.text = songs[indexPath.row].songtitle
        cell.artist.text = songs[indexPath.row].artist
        return cell
    }
}
