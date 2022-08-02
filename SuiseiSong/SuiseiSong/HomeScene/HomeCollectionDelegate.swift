//
//  SuggestCollectionDelegate.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/08/01.
//

//import UIKit
//
//class HomeCollectionDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
//
//    var songs: [Song]
//    var navigationController: UINavigationController?
//
//    init(songs: [Song], navigationController: UINavigationController) {
//        self.songs = songs
//        self.navigationController = navigationController
//        super.init()
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return songs.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        //storyboard上のセルを生成　storyboardのIdentifierで付けたものをここで設定する
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "monthlyCell", for: indexPath) as! SuggestCollectionCell
//
//        // セルに対応する歌をセット
//        let index = indexPath.row
//        cell.song = songs[index]
//
//        return cell
//    }
//}
