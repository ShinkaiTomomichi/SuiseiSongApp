//
//  SongTableCell.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/15.
//

import UIKit
import YouTubeiOSPlayerHelper

class SongTableCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var artist: UILabel!
    
    var song: Song? = nil {
        didSet {
            if let song = self.song {
                self.title.text = song.songtitle
                self.artist.text = song.artist
            }
        }
    }
    // nextを決める際に必要
    var index: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // tapした時のみ
        if selected {
            YTPlayerViewWrapper.shared.setSelectedIdAndSong(selectedId: index,
                                                            selectedSong: song!)
        }
    }
}
