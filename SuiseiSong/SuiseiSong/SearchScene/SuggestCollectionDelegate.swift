//
//  SuggestCollectionDelegate.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/08/01.
//

import UIKit

class SuggestCollectionDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
        
    var songs: [Song]
    var navigationController: UINavigationController?
    
    init(songs: [Song], navigationController: UINavigationController) {
        self.songs = songs
        self.navigationController = navigationController
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return songs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //storyboard上のセルを生成　storyboardのIdentifierで付けたものをここで設定する
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "monthlyCell", for: indexPath) as! SuggestCollectionCell
        
        // セルに対応する歌をセット
        let index = indexPath.row
        cell.song = songs[index]
        
        return cell
    }
    
//    // セルの間隔
//    private func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimunLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 10
//    }
    
    // セルタップ時
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        Logger.log(message: "タップされました")
//
//        let storyboard = UIStoryboard(name: "Play", bundle: nil)
//        let nextViewController = storyboard.instantiateViewController(withIdentifier: "Play") as! ViewController
//
//        let index = indexPath.row
//        SelectedStatus.shared.setSelectedSong(song: songs[index])
//
//        self.navigationController?.pushViewController(nextViewController, animated: true)
//
//        // 2回目の表示の時にWebViewがloadされていない
//        // 単純に2回呼ばれる想定じゃないからloadが入らなくなってるっぽい
//        // selectedVideoのIDが変わらないため、これは終了時に消せばいけそうだが
//    }
}
