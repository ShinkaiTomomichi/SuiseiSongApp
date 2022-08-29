//
//  PlayListModuleCollectionViewCell.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/08/13.
//

import UIKit

class PlayListModuleCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var songCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCell(title: String, songsCount: Int, icon: UIImage) {
        self.title.text = title
        self.icon.image = icon
        self.songCount.text = String(songsCount) + "曲"
    }
}
