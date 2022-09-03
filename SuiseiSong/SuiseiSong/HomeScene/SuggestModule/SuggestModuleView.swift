//
//  SuggestModuleStackView.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/08/02.
//

import UIKit

// @IBDesignable // TODO: バグるため修正
class SuggestModuleView: UIView {
    
    var view: UIView!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // 直接Songsを渡せば早いのでは？
    var songs: [Song] = []
    var navigationController: UINavigationController?
        
    // TODO: 丸々コピペなので内容の理解
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupXib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupXib()
    }
    
    func setupXib() {
        let nib = UINib(nibName: "SuggestModule", bundle: nil)
        // xibのCustomClassではなくOwnerFileに設定する
        view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        view.frame = bounds
        addSubview(view)
        setupDelegate()
    }
    
    func setupDelegate() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        // モジュールによってセルを変える場合は上記if分に含める
        self.collectionView.register(UINib(nibName: "SuggestModuleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SuggestModuleCollectionViewCell")
    }
    
    @IBAction func tapMoreButton(_ sender: Any) {
        // 遷移する前にdiplaySongsに現在の情報をセットする
        Songs.shared.setDisplaySongs(songs: self.songs)
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "Search") as! SearchViewController
        if let navigationController = navigationController {
            navigationController.pushViewController(nextViewController, animated: true)
        } else {
            Logger.log(message: "navigationControllerのセットが完了していません")
        }
    }
        
    func setup(title: String, songs: [Song], navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.title.text = title
        self.songs = songs
    }
    
    func resetSongs(songs: [Song]) {
        self.songs = songs
        self.collectionView.reloadData()
    }
}

extension SuggestModuleView: UICollectionViewDelegate, UICollectionViewDataSource {
    // セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if songs.count < 10 {
            return songs.count
        } else {
            return 10
        }
    }
    
    // セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //storyboard上のセルを生成　storyboardのIdentifierで付けたものをここで設定する
        var cell: SuggestModuleCollectionViewCell
        let index = indexPath.row
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestModuleCollectionViewCell", for: indexPath) as! SuggestModuleCollectionViewCell
        cell.song = songs[index]
        
        return cell
    }
    
    // セルタップ時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Logger.log(message: "タップされました")
        
        // cellを使う時はVCの方から渡してやる
        let storyboard = UIStoryboard(name: "Play", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "Play") as! PlayViewController
        
        if let cell = collectionView.cellForItem(at: indexPath) as? SuggestModuleCollectionViewCell {
            SelectedStatus.shared.setSelectedSong(song: cell.song!, filterCompletion: {
                Songs.shared.setDisplaySongs(songs: self.songs)
            })
        }
        
        if let navigationController = navigationController {
            navigationController.pushViewController(nextViewController, animated: true)
        } else {
            Logger.log(message: "navigationControllerのセットが完了していません")
        }
    }
}
