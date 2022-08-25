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
    
    // セットした時にアイコンなどを設定する
    var holoMember: String? = nil {
        // songをセットした際に自動で他の要素をセットする
        didSet {
            if let holoMember = self.holoMember{
                self.title.text = holoMember
                self.icon.image = ImageCaches.shared.holomembersCaches[holoMember]
                if let holoMembersSongs = Songs.shared.holoMembersSongs[holoMember] {
                    self.songCount.text = String(holoMembersSongs.count) + "曲"
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
}
