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
        self.image.image = ImageCaches.shared.caches[videoId]
    }
}
