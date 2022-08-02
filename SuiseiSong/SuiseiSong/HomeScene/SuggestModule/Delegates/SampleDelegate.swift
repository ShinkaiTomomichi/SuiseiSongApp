//
//  SuggestCollectionDelegate.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/08/01.
//

import UIKit

class SampleDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    var navigationController: UINavigationController?
    
    // セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Songs.shared.favoriteSongs.count
    }
    
    // セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //storyboard上のセルを生成　storyboardのIdentifierで付けたものをここで設定する
        var cell: SuggestModuleCollectionViewCell
        let index = indexPath.row
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestModuleCollectionViewCell", for: indexPath) as! SuggestModuleCollectionViewCell
        cell.song = Songs.shared.favoriteSongs[index]
        
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
                Songs.shared.setFavorite()
            })
        }
        
        if let navigationController = navigationController {
            navigationController.pushViewController(nextViewController, animated: true)
        } else {
            Logger.log(message: "navigationControllerへのセットが完了していません")
        }
    }
}
