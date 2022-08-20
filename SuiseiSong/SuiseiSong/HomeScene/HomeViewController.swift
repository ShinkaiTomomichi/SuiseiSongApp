//
//  SearchViewController.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/24.
//

import UIKit

class HomeViewController: UIViewController {
    // 新着、お気に入り、履歴、ライブ、オリジナル曲、コラボ、くらいのジャンル分け
    // ScrollViewよりもcellを可変にしたTableViewの方が良いか？？？
    // お気に入りと履歴は読みこむたびに更新してほしい（willAppearで）
    
    @IBOutlet weak var recentView: SuggestModuleView!
    @IBOutlet weak var favorite202207View: SuggestModuleView!
    @IBOutlet weak var favorite202206View: SuggestModuleView!
    // @IBOutlet weak var rockView: SuggestModuleView!
    // @IBOutlet weak var animeView: SuggestModuleView!
    @IBOutlet weak var live3DView: SuggestModuleView!
    @IBOutlet weak var historyView: SuggestModuleView!
    @IBOutlet weak var favoriteView: SuggestModuleView!
    
    // 暫定的なplaylistview
    @IBOutlet weak var playlistView: PlayListView!
    
    // NavigationBarに追加するボタン
    var settingBarButtonItem: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        Songs.shared.resetHeaders()
        historyView.collectionView.reloadData()
        favoriteView.collectionView.reloadData()
        
        historyView.isHidden = Histories.shared.historyIds.count == 0
        favoriteView.isHidden = Favorites.shared.favoriteIds.count == 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Songs.shared.setup()
        
        // 煩雑なので効率化したい
        // property一覧を取得するなど少しトリッキーな実装が必要そう
        recentView.setNavigationController(self.navigationController)
        favorite202207View.setNavigationController(self.navigationController)
        favorite202206View.setNavigationController(self.navigationController)
        // rockView.setNavigationController(self.navigationController)
        // animeView.setNavigationController(self.navigationController)
        live3DView.setNavigationController(self.navigationController)
        historyView.setNavigationController(self.navigationController)
        favoriteView.setNavigationController(self.navigationController)
        // PlayListModuleにも渡す
        playlistView.setNavigationController(self.navigationController)
        
        settingBarButtonItem = UIBarButtonItem(image: UIImage.initWithDarkmode(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(settingBarButtonTapped(_:)))
        
        self.navigationItem.rightBarButtonItems = [settingBarButtonItem]
        
        // UXが低いので一旦無効化
        // TODO: ユーザの直感には反するため改善策を検討
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    @objc func settingBarButtonTapped(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "Setting") as! SettingViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}


