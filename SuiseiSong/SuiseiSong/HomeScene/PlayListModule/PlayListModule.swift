//
//  PlayListModule.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/08/13.
//

import UIKit

// 一旦ホロメン用のモジュールとして作成
class PlayListView: UIView {
    
    var view: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var navigationController: UINavigationController?
    
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
    
    // tapする前に
    func setNavigationController(_ navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
}

extension PlayListView: UICollectionViewDelegate, UICollectionViewDataSource {
    // セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    // セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: PlayListModuleCollectionViewCell
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayListModuleCollectionViewCell", for: indexPath) as! PlayListModuleCollectionViewCell
        cell.holomember = Songs.shared.holomembers[indexPath.row]
        return cell
    }
    
    // セルタップ時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Logger.log(message: "タップされました")
        
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "Search") as! SearchViewController
        
        if let navigationController = self.navigationController,
            let song = Songs.shared.holomembersSongs[Songs.shared.holomembers[indexPath.row]] {
            Songs.shared.setFilteredSongs(songs: song)
            navigationController.pushViewController(nextViewController, animated: true)
        } else {
            Logger.log(message: "navigationControllerのセットが完了していません")
        }
    }
}
