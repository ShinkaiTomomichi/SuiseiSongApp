//
//  SuggestModuleStackView.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/08/02.
//

import UIKit

// @IBDesignable // TODO: バグるため修正
// レイアウトが異なるためアーティストやジャンル用のモジュールは別で用意する TODO: 共通化の検討
class SuggestModuleView: UIView {
    
    var view: UIView!
    let tagAndSuggestModuleViewTypeDict: Dictionary<Int, SuggestModuleViewType> = [
        0: .recent,
        1: .favorite202207,
        2: .favorite202206,
    ]
    
    // もしかしたらデータ自体を持った方が良いか？
    // 10000件コピーとかだと困るが、少数ならメモリ管理も考える
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate : SuggestModuleViewDelegateProtocol?
    var suggestModuleViewType: SuggestModuleViewType?
    var filteredCompletion: (() -> Void)?
    
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
        view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        view.frame = bounds
        addSubview(view)
        setupDelegate()
    }
    
    func setupDelegate() {
        // ここでtagを取得して解釈のしやすいenumに変換する
        suggestModuleViewType = tagAndSuggestModuleViewTypeDict[tag]
        switch suggestModuleViewType {
        case .recent:
            delegate = RecentDelegate()
            filteredCompletion = {
                Songs.shared.reset()
            }
            self.title.text = "最近の動画"
        case .favorite202207:
            delegate = Favorite202207Delegate()
            filteredCompletion = {
                Songs.shared.setFilteredSongs(songs: Songs.shared.favorite202207Songs)
            }
            self.title.text = "7月のおすすめ"
        case .favorite202206:
            delegate = Favorite202206Delegate()
            filteredCompletion = {
                Songs.shared.setFilteredSongs(songs: Songs.shared.favorite202206Songs)
            }
            self.title.text = "6月のおすすめ"
        default:
            fatalError("suggestModuleViewTypeの設定でエラーが発生しました")
        }

        delegate?.filterCompletion = filteredCompletion
        self.collectionView.delegate = delegate
        self.collectionView.dataSource = delegate
        // モジュールによってセルを変える場合は上記if分に含める
        self.collectionView.register(UINib(nibName: "SuggestModuleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SuggestModuleCollectionViewCell")
    }
    
    // tapする前に
    func setNavigationController(_ navigationController: UINavigationController?) {
        delegate?.navigationController = navigationController
    }
    
    @IBAction func tapMoreButton(_ sender: Any) {        
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "Search") as! SearchViewController
        
        if let navigationController = delegate?.navigationController,
            let filteredCompletion = filteredCompletion {
            filteredCompletion()
            navigationController.pushViewController(nextViewController, animated: true)
        } else {
            Logger.log(message: "navigationControllerのセットが完了していません")
        }
    }
}

enum SuggestModuleViewType {
    case recent
    case favorite202207
    case favorite202206
}
