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
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // モジュールによってセルを変える場合は上記if分に含める
        self.collectionView.register(UINib(nibName: "PlayListModuleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PlayListModuleCollectionViewCell")
    }
}

extension PlayListView: UICollectionViewDelegate, UICollectionViewDataSource {
    // セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    // セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: PlayListModuleCollectionViewCell
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayListModuleCollectionViewCell", for: indexPath) as! PlayListModuleCollectionViewCell
        
        return cell
    }
}
