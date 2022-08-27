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
    // TODO: 番号じゃなくてIDで管理したい
    let suggestModuleViewTypeDict: Dictionary<String, SuggestModuleViewType> = [
        "Recent": .recent,
        "Favorite202207": .favorite202207,
        "Favorite202206": .favorite202206,
        "Rock": .rock,
        "Anime": .anime,
        "3DLive": .live3d,
        "History": .history,
        "Favorite": .favorite,
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
        // xibのCustomClassではなくOwnerFileに設定する
        view = nib.instantiate(withOwner: self, options: nil).first as? UIView
        view.frame = bounds

        addSubview(view)
        setupDelegate()
    }
    
    func setupDelegate() {
        guard let restorationIdentifier = self.restorationIdentifier else {
            return
        }
        suggestModuleViewType = suggestModuleViewTypeDict[restorationIdentifier]
        switch suggestModuleViewType {
        case .recent:
            delegate = RecentDelegate()
            filteredCompletion = {
                Songs.shared.resetDisplaySongs()
            }
            self.title.text = "最近の動画"
        case .favorite202207:
            delegate = Favorite202207Delegate()
            filteredCompletion = {
                // 画面に送る時にfilteredにセットする方式にする
                Songs.shared.setDisplaySongs(songs: Songs.shared.favorite202207Songs)
            }
            self.title.text = "7月のおすすめ"
        case .favorite202206:
            delegate = Favorite202206Delegate()
            filteredCompletion = {
                Songs.shared.setDisplaySongs(songs: Songs.shared.favorite202206Songs)
            }
            self.title.text = "6月のおすすめ"
        case .rock:
            delegate = RockDelegate()
            filteredCompletion = {
                Songs.shared.setDisplaySongs(songs: Songs.shared.rockSongs)
            }
            self.title.text = "ロック"
        case .anime:
            delegate = AnimeDelegate()
            filteredCompletion = {
                Songs.shared.setDisplaySongs(songs: Songs.shared.animeSongs)
            }
            self.title.text = "アニメ"
        case .live3d:
            delegate = Live3DDelegate()
            filteredCompletion = {
                Songs.shared.setDisplaySongs(songs: Songs.shared.live3DSongs)
            }
            self.title.text = "3Dライブ"
        case .history:
            delegate = HistoryDelegate()
            filteredCompletion = {
                Songs.shared.setDisplaySongs(songs: Songs.shared.historySongs)
            }
            self.title.text = "履歴"
        case .favorite:
            delegate = FavoriteDelegate()
            filteredCompletion = {
                Songs.shared.setDisplaySongs(songs: Songs.shared.favoriteSongs)
            }
            self.title.text = "お気に入り"
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
    case anime
    case rock
    case live3d
    case history
    case favorite
}
