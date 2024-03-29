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
    @IBOutlet weak var selectedView: UIView!
    
    var song: Song? = nil {
        // songをセットした際に自動で他の要素をセットする
        didSet {
            if let song = self.song {
                self.title.text = song.songname
                self.artist.text = song.artistname
                getImageByVideoId(videoId: song.videoid)
                setFavoriteStar()
            }
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        selectedView.isUserInteractionEnabled = false
    }
    
    @IBAction func tapFavoriteButton(_ sender: Any) {
        song?.favorite.toggle()
        setFavoriteStar()
        if let song = song {
            setFavorites(videoId: song.videoid)
        }
    }

    func reloadSelected() {
        if let song = self.song,
            let selectedSong = SelectedStatus.shared.song,
           song.id == selectedSong.id {
            selectedView.alpha = 0.5            
        } else {
            selectedView.alpha = 0.0
        }
    }
    
    // Youtubeのサムネイル画像を取得
    // 現状cellの描画以外に利用しないためcell直下に用意
    private func getImageByVideoId(videoId: String) {
        self.icon.image = ImageCaches.shared.getImageThumbnail(byVideoId: videoId)
    }
    
    private func setFavoriteStar() {
        guard let song = self.song else {
            return
        }
        if song.favorite {
            // ここだけ水色に変えておく
            let suiseiColor = UIColor(red: 29/255, green: 167/255, blue: 250/255, alpha: 1.0)
            self.favorite.setImage(UIImage(systemName: "star.fill")?.withTintColor(suiseiColor, renderingMode: .alwaysOriginal), for: .normal)
        } else {
            self.favorite.setImage(UIImage.initWithTintColorWhite(systemName: "star"), for: .normal)
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
