//
//  SuggestCollectionCell.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/30.
//

import UIKit

class SuggestVideoCollectionViewCell: UICollectionViewCell {
    
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
        if let image = song?.thumbnail {
            self.image.image = image
        } else {
            let urlWithVideoId = "https://i.ytimg.com/vi/\(videoId)/hqdefault.jpg"
            let url = URL(string: urlWithVideoId)
            do {
                let data = try Data(contentsOf: url!)
                let image = UIImage(data: data)!
                self.image.image = image
                song?.thumbnail = image
            } catch let err {
                print("Error : \(err.localizedDescription)")
                self.image.image = UIImage(systemName: "xmark.circle.fill")!
            }
        }
        // 角を丸くする（ここは別処理に分割しても良いかも）
        self.image.layer.cornerRadius = self.image.frame.size.width * 0.05
        self.image.clipsToBounds = true
    }
}
