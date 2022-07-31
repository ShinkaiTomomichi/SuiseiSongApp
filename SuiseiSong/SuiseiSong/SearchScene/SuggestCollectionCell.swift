//
//  SuggestCollectionCell.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/30.
//

import UIKit

class SuggestCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    var song: Song? = nil {
        // songをセットした際に自動で他の要素をセットする
        didSet {
            if let song = self.song {
                 self.label.text = song.songtitle
                 getImageByVideoId(videoId: song.videoid)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // Youtubeのサムネイル画像を取得
    private func getImageByVideoId(videoId: String) {
        let urlWithVideoId = "https://i.ytimg.com/vi/\(videoId)/hqdefault.jpg"
        let url = URL(string: urlWithVideoId)
        do {
            let data = try Data(contentsOf: url!)
            self.image.image = UIImage(data: data)!
        } catch let err {
            print("Error : \(err.localizedDescription)")
            self.image.image = UIImage(systemName: "xmark.circle.fill")!
        }
        // 角を丸くする処理が思った感じに動いていない...
        // こちらはそのうち改善したい
         self.image.layer.cornerRadius = self.image.frame.size.width * 0.05
         self.image.clipsToBounds = true
    }
}
