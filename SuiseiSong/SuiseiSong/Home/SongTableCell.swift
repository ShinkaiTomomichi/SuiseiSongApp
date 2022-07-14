//
//  SongTableCell.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/15.
//

import UIKit

class SongTableCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var artist: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // tapした時にyoutubeViewを触りたいのだが、、、引数渡しをせずにやるには？

}
