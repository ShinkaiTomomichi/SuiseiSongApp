//
//  SongTableCell.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/15.
//

import UIKit

class SongTableViewCell: UITableViewCell {
    
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
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 曲の選択はNextに進んだ場合にも反映する必要があるため、タップとは別に実装する必要がある
        self.selectionStyle = .none
                
        // お気に入り機能を反映させる
        // ここだけDBではなくUDから参照する
        // これはローカルのデータベースに保存しておくのが楽か？
        // amazonなどの場合表示する度に描画するべきだが、うちのデータベースは高々1000件と考えると前もった処理の方が単純か？
        self.favorite.setImage(UIImage.initWithDarkmode(systemName: "star"), for: .normal)
        // self.favorite.setImage(UIImage(systemName: "star.fill"), for: .normal)
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
