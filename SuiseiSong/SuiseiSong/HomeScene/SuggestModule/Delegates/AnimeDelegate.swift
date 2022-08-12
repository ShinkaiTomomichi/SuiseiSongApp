//
//  AnimeDelegate.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/08/11.
//

import UIKit

class AnimeDelegate: NSObject, SuggestModuleViewDelegateProtocol {
    var navigationController: UINavigationController?
    var filterCompletion: (() -> Void)?
    
    // セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Songs.shared.animeSongs.count
    }
    
    // セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //storyboard上のセルを生成　storyboardのIdentifierで付けたものをここで設定する
        var cell: SuggestModuleCollectionViewCell
        let index = indexPath.row
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestModuleCollectionViewCell", for: indexPath) as! SuggestModuleCollectionViewCell
        cell.song = Songs.shared.animeSongs[index]
        
        return cell
    }
    
    // セルタップ時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Logger.log(message: "タップされました")
        
        // cellを使う時はVCの方から渡してやる
        let storyboard = UIStoryboard(name: "Play", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "Play") as! PlayViewController
        
        if let cell = collectionView.cellForItem(at: indexPath) as? SuggestModuleCollectionViewCell,
            let filterCompletion = self.filterCompletion {
            SelectedStatus.shared.setSelectedSong(song: cell.song!, filterCompletion: {
                filterCompletion()
            })
        }
        
        if let navigationController = navigationController {
            navigationController.pushViewController(nextViewController, animated: true)
        } else {
            Logger.log(message: "navigationControllerのセットが完了していません")
        }
    }
}
