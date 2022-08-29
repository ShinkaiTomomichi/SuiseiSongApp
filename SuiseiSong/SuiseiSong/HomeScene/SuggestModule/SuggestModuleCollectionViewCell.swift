//
//  SuggestModuleCollectionViewCell.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/08/02.
//

import UIKit

class SuggestModuleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var artist: UILabel!
    
    var song: Song? = nil {
        // songをセットした際に自動で他の要素をセットする
        didSet {
            if let song = self.song {
                self.title.text = song.songname
                self.artist.text = song.artistname
                getImageByVideoId(videoId: song.videoid)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Youtubeのサムネイル画像を取得
    private func getImageByVideoId(videoId: String) {
        self.icon.image = ImageCaches.shared.caches[videoId]
    }
}
