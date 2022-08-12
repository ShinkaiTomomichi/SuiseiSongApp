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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.icon.image = UIImage(systemName: "xmark.circle.fill")!
    }
}
