//
//  PlayListModule.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/08/13.
//

import UIKit

class PlayListView: UIView {
    
    var view: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var navigationController: UINavigationController?
    
    // 多重リストとiconのキャッシュをプロパティとして持つ
    var playListKeys: [String] = []
    var playListSongs: [String: [Song]] = [:]
    var playListIcons: [String: UIImage] = [:]
    
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
        
    func setupPlayListModule(title: String, keys: [String], songs: [String: [Song]], icons: [String: UIImage], navigationController: UINavigationController?) {
        self.title.text = title
        self.playListKeys = keys
        self.playListSongs = songs
        self.playListIcons = icons
        self.navigationController = navigationController
    }
}

extension PlayListView: UICollectionViewDelegate, UICollectionViewDataSource {
    // セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playListSongs.keys.count
    }
    
    // セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell: PlayListModuleCollectionViewCell
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayListModuleCollectionViewCell", for: indexPath) as! PlayListModuleCollectionViewCell
        
        let key = playListKeys[indexPath.row]
        if let songs = playListSongs[key], let icon = playListIcons[key] {
            cell.setCell(title: key, songsCount: songs.count, icon: icon)
        }
        return cell
    }
    
    // セルタップ時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "Search") as! SearchViewController
        
        if let navigationController = self.navigationController,
            let songs = playListSongs[playListKeys[indexPath.row]] {
            Songs.shared.setDisplaySongs(songs: songs)
            navigationController.pushViewController(nextViewController, animated: true)
        } else {
            Logger.log(message: "navigationControllerのセットが完了していません")
        }
    }
}
