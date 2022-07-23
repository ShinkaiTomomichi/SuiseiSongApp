//
//  SongTableCell.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/15.
//

import UIKit
import YouTubeiOSPlayerHelper

class SongTableCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var favorite: UIButton!
    
    var song: Song? = nil {
        // songをセットした際に自動で他の要素をセットする
        didSet {
            if let song = self.song {
                self.title.text = song.songtitle
                self.artist.text = song.artist
                getImageByVideoId(videoId: song.videoid)
            }
        }
    }
    // nextを決める際に必要
    var index: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // お気に入り機能を反映させる
        // ここだけDBではなくUDから参照する
        
        // これはローカルのデータベースに保存しておくのが楽か？
        // amazonなどの場合表示する度に描画するべきだが、うちのデータベースは高々1000件と考えると前もった処理の方が単純か？
        
        self.favorite.setImage(UIImage(systemName: "star"), for: .normal)
        // self.favorite.setImage(UIImage(systemName: "star.fill"), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // tapした時のみ
        if selected {
            YTPlayerViewWrapper.shared.setSelectedIdAndSong(selectedId: index,
                                                            selectedSong: song!)
        }
    }
    
    // Youtubeのサムネイル画像を取得
    // 現状cellの描画以外に利用しないためcell直下に用意
    private func getImageByVideoId(videoId: String) {
        let urlWithVideoId = "https://i.ytimg.com/vi/\(videoId)/hqdefault.jpg"
        let url = URL(string: urlWithVideoId)
        do {
            let data = try Data(contentsOf: url!)
            self.icon.image = UIImage(data: data)!
        } catch let err {
            print("Error : \(err.localizedDescription)")
            self.icon.image = UIImage(systemName: "xmark.circle.fill")!
        }
        // 角を丸くする（ここは別処理に分割しても良いかも）
        self.icon.layer.cornerRadius = self.icon.frame.size.width * 0.05
        self.icon.clipsToBounds = true
    }
}
