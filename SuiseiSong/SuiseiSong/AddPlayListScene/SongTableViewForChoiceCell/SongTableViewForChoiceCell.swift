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
    
    var song: Song? = nil {
        // songをセットした際に自動で他の要素をセットする
        didSet {
            if let song = self.song {
                self.title.text = song.songtitle
                self.artist.text = song.artist
                getImageByVideoId(videoId: song.videoid)
                // setChoice()
            }
        }
    }
    
    var viewController: UIViewController?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    @IBAction func tapChoiceButton(_ sender: Any) {
        song?.favorite.toggle()
        // setFavoriteStar()
        if let song = song {
            setFavorites(videoId: song.videoid)
        }
    }
    
    // Youtubeのサムネイル画像を取得
    // 現状cellの描画以外に利用しないためcell直下に用意
    private func getImageByVideoId(videoId: String) {
        self.icon.image = ImageCaches.shared.caches[videoId]
    }
    
    //
    private func setChoiceButton() {
        guard let song = self.song else {
            return
        }
        if song.favorite {
            // ここだけ水色に変えておく
            let suiseiColor = UIColor(red: 29/255, green: 167/255, blue: 250/255, alpha: 1.0)
            self.choice.setImage(UIImage(systemName: "star.fill")?.withTintColor(suiseiColor, renderingMode: .alwaysOriginal), for: .normal)
        } else {
            self.choice.setImage(UIImage.initWithTintColorWhite(systemName: "star"), for: .normal)
        }
    }
    
    private func setFavorites(videoId: String) {
        guard let song = self.song else {
            return
        }
        if song.favorite {
            Favorites.shared.addFavorite(songId: song.id)
        } else {
            Favorites.shared.removeFavorite(songId: song.id)
        }
        // Songs.shared.setFavorite(songId: song.id, favorite: song.favorite)
    }
}
