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
    
    var song: Song? = nil {
        // songをセットした際に自動で他の要素をセットする
        didSet {
            if let song = self.song {
                 self.title.text = song.songtitle
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
        let urlWithVideoId = "https://i.ytimg.com/vi/\(videoId)/hqdefault.jpg"
        let url = URL(string: urlWithVideoId)
        do {
            let data = try Data(contentsOf: url!)
            self.icon.image = UIImage(data: data)!
        } catch let err {
            print("Error : \(err.localizedDescription)")
            self.icon.image = UIImage(systemName: "xmark.circle.fill")!
        }
        
         self.icon.layer.cornerRadius = self.icon.frame.size.width * 0.05
         self.icon.clipsToBounds = true
    }
}
