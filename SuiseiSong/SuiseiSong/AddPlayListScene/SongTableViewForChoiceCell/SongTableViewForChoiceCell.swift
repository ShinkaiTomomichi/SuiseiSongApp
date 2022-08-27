//
//  SongTableViewCellForChoice.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/08/27.
//

import UIKit

// checkboxの切り替えを行い保存時にtableViewのcell一覧を確認する必要がある...
// cellベースにするとfilterした時面倒なので,,,ViewControllerに紐づけるのが楽か?
// Notificationでもできるがもうちょっと結合を楽にしたい
// 普通にVCをぶら下げて、そこの保存リストに格納するとかでいいか?
// この方法であればIDの一覧を記録することくらいはできるか
// そのあとはプレイリストモジュールを作れば一通りは問題ないか
class SongTableViewForChoiceCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var artist: UILabel!
    @IBOutlet weak var choice: UIButton!

    // うーむ、Songに格納してしまうのが楽かね???
    var song: Song? = nil {
        // songをセットした際に自動で他の要素をセットする
        didSet {
            if let song = self.song {
                self.title.text = song.songtitle
                self.artist.text = song.artist
                getImageByVideoId(videoId: song.videoid)
                setChoiceButton(enable: song.choice)
            }
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    @IBAction func tapChoiceButton(_ sender: Any) {
        if let song = song {
            song.choice.toggle()
            setChoiceButton(enable: song.choice)
        }
    }
    
    // Youtubeのサムネイル画像を取得
    // 現状cellの描画以外に利用しないためcell直下に用意
    private func getImageByVideoId(videoId: String) {
        self.icon.image = ImageCaches.shared.caches[videoId]
    }
    
    private func setChoiceButton(enable: Bool) {
        if enable {
            self.choice.setImage(UIImage.initWithTintColorWhite(systemName: "checkmark.square.fill"), for: .normal)
        } else {
            self.choice.setImage(UIImage.initWithTintColorWhite(systemName: "square"), for: .normal)
        }
    }
}
