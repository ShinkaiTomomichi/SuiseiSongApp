//
//  SearchViewController.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/24.
//

import UIKit

class HomeViewController: UIViewController {
    // 新着、お気に入り、履歴、ライブ、オリジナル曲、コラボ、くらいのジャンル分け
    // このモジュールは明らかに複製しておく必要がある
    // 現状テーブルなのでscrollViewにしておきたい
    
    // collectionViewの親クラスを作った方が使いやすそう
    @IBOutlet weak var suggestCollectionView: UICollectionView!
    @IBOutlet weak var monthlyCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Songs.shared.setup()
        
        // NavigationBarのタイトル
        // ここは画像などに差し替えた方が良さそう
        self.title = "すいちゃんのうた"
        
        // このようなテーブルを複製する場合どのようにモジュール化するのがベストか???
        suggestCollectionView.delegate = self
        suggestCollectionView.dataSource = self
        
        // Delegateを他のクラスに切り分ける方法がうまく機能しなかった、TODO: 要調査
        monthlyCollectionView.delegate = self
        monthlyCollectionView.dataSource = self
        
        // UXが低いので一旦無効化、TODO: ユーザの直感には反するため、改善策を検討
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}

// 現状tableViewの種類に応じてSourceの切り分けを実施しているが綺麗ではない、TODO: ソースコードごとに管理
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == suggestCollectionView{
            return 5
        } else {
            return Songs.shared.favoriteSongs.count
        }
    }
    
    // セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //storyboard上のセルを生成　storyboardのIdentifierで付けたものをここで設定する
        var cell: SuggestVideoCollectionViewCell
        let index = indexPath.row
        if collectionView == suggestCollectionView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "suggestCell", for: indexPath) as! SuggestVideoCollectionViewCell
            cell.song = Songs.shared.allSongs[index]
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "monthlyCell", for: indexPath) as! SuggestVideoCollectionViewCell
            cell.song = Songs.shared.favoriteSongs[index]
        }

        return cell
    }
    
    // セルの間隔
    private func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimunLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // セルタップ時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Logger.log(message: "タップされました")
        
        let storyboard = UIStoryboard(name: "Play", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "Play") as! PlayViewController
        
        // TODO: 強制アンラップが雑なので後で直す
        if collectionView == suggestCollectionView {
            if let cell = self.suggestCollectionView.cellForItem(at: indexPath) as? SuggestVideoCollectionViewCell {
                SelectedStatus.shared.setSelectedSong(song: cell.song!, filterCompletion: {
                    Songs.shared.reset()
                })
            }
        } else {
            if let cell = self.monthlyCollectionView.cellForItem(at: indexPath) as? SuggestVideoCollectionViewCell {
                SelectedStatus.shared.setSelectedSong(song: cell.song!, filterCompletion: {
                    Songs.shared.setFavorite()
                })
            }
        }
        
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
