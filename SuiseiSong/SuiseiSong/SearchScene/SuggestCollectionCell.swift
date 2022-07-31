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
        
        self.label.text = "サンプル"
        self.image.image = UIImage(systemName: "xmark.circle.fill")!
        // self.image.image = UIImage.initWithDarkmode(systemName: "star")
        // self.label.text = "sample"
    }
    
    // Youtubeのサムネイル画像を取得
    // 現状cellの描画以外に利用しないためcell直下に用意
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
        // 角を丸くする（ここは別処理に分割しても良いかも）
        self.image.layer.cornerRadius = self.image.frame.size.width * 0.05
        self.image.clipsToBounds = true
    }
}
