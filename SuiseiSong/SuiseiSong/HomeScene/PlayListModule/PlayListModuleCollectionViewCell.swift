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
    
    // セットした時にアイコンなどを設定する
    var holomember: String? = nil {
        // songをセットした際に自動で他の要素をセットする
        didSet {
            if let holomember = self.holomember{
                self.title.text = holomember
                self.icon.image = ImageCaches.shared.holomembersCaches[holomember]
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
}
