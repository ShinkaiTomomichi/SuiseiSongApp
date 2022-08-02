//
//  SuggestModuleStackView.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/08/02.
//

import UIKit

// @IBDesignable
class SuggestModuleView: UIView {
    
    var view: UIView!
    let tagList: Dictionary = [
        0: "",
        1: "",
    ]
    var type: String = ""
    
    // もしかしたらデータ自体を持った方が良いか？
    // 10000件コピーとかだと困るが、少数ならメモリ管理も考える
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // 互いに参照するため、どちらかを弱依存にしたい
    // TODO: この辺りの挙動を要確認
    var myDelegate : SampleDelegate?
    
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
        // backgroundColor = UIColor.clear
        
        let nib = UINib(nibName: "SuggestModule", bundle: nil)
        view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        // use bounds not frame or it'll be offset
        view.frame = bounds
        // Adding custom subview on top of our view
        addSubview(view)
        
        setupDelegate()
    }
    
    func setupDelegate() {
        // ここでtagを取得して解釈のしやすいenumに変換する
        
        // enumに応じてセット内容を変更
        // Delegateは別クラスにて管理する
        
        // 以下の方法でDelegateを別クラスに分離可能
        myDelegate = SampleDelegate()
        self.collectionView.delegate = myDelegate
        self.collectionView.dataSource = myDelegate
        // 呼び出すモジュールによってcellの種類は変えたい
        self.collectionView.register(UINib(nibName: "SuggestModuleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SuggestModuleCollectionViewCell")
    }
    
    // これが呼ばれる前にtapが走るとフリーズする
    func setup(navigationController: UINavigationController?, title: String) {
        myDelegate?.navigationController = navigationController
        self.title.text = title
    }
}

// 現状モジュールの種別をtagによって分類できているが、もう少し分かりやすい管理がしたい
//extension SuggestModuleView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//
//    // セルの数
//    // モジュールによって変える
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if self.tag == 0 {
//            return Songs.shared.favoriteSongs.count
//        } else if self.tag == 1 {
//            return 5
//        } else {
//            return Songs.shared.favoriteSongs.count
//        }
//    }
//
//    // セルの中身
//    // モジュールによって変える
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        //storyboard上のセルを生成　storyboardのIdentifierで付けたものをここで設定する
//        var cell: SuggestModuleCollectionViewCell
//        let index = indexPath.row
//        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SuggestModuleCollectionViewCell", for: indexPath) as! SuggestModuleCollectionViewCell
//        cell.song = Songs.shared.favoriteSongs[index]
//
//        return cell
//    }
//
//    // セルタップ時
//    // モジュールによって変える
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        Logger.log(message: "タップされました")
//
//        let storyboard = UIStoryboard(name: "Play", bundle: nil)
//        let nextViewController = storyboard.instantiateViewController(withIdentifier: "Play") as! PlayViewController
//
//        // TODO: 強制アンラップが雑なので後で直す
//        if let cell = self.collectionView.cellForItem(at: indexPath) as? SuggestModuleCollectionViewCell {
//            SelectedStatus.shared.setSelectedSong(song: cell.song!, filterCompletion: {
//                Songs.shared.setFavorite()
//            })
//        }
//
//        // viewControllerを渡す必要がある
//        self.navigationController?.pushViewController(nextViewController, animated: true)
//    }
//}
