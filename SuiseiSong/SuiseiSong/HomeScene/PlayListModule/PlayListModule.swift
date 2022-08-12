//
//  PlayListModule.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/08/13.
//

import UIKit

class PlayListView: UIView {
    
    var view: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
    }
    
    func setupXib() {
        let nib = UINib(nibName: "PlayListModule", bundle: nil)
        view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        view.frame = bounds
        addSubview(view)
        setupDelegate()
    }
    
    func setupDelegate() {
        let delegate = RockDelegate()
        self.collectionView.delegate = delegate
        self.collectionView.dataSource = delegate
        // モジュールによってセルを変える場合は上記if分に含める
        self.collectionView.register(UINib(nibName: "SuggestModuleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SuggestModuleCollectionViewCell")
    }
}

extension PlayListView: UICollectionViewDelegate, UICollectionViewDataSource {
    // セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Songs.shared.rockSongs.count
    }
    
    // セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //storyboard上のセルを生成　storyboardのIdentifierで付けたものをここで設定する
        var cell: SuggestModuleCollectionViewCell
        let index = indexPath.row
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestModuleCollectionViewCell", for: indexPath) as! SuggestModuleCollectionViewCell
        cell.song = Songs.shared.rockSongs[index]
        
        return cell
    }
}
