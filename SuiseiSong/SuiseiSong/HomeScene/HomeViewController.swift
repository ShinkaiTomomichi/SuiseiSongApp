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
    var addPlayListBarButtonItem: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ここで毎回シャッフルすると
        // あー他のテーブルを更新してないから変な感じになるのか
        Songs.shared.sortOtherSongs()
        loadHistoryAndFavoriteView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        settingBarButtonItem = UIBarButtonItem(image: UIImage.initWithTintColorWhite(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(settingBarButtonTapped(_:)))
        addPlayListBarButtonItem = UIBarButtonItem(image: UIImage.initWithTintColorWhite(systemName: "plus"), style: .plain, target: self, action: #selector(addPlayListBarButtonTapped(_:)))
        
        self.navigationItem.rightBarButtonItems = [settingBarButtonItem, addPlayListBarButtonItem]
        
        // フリックを入れるとスライダーと相性が悪いので無効化
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        // NavigationBarの文字色を変更
        self.navigationController?.navigationBar.tintColor = .white
        
        setupBackground()
    }
    
    private func loadHistoryAndFavoriteView() {
        reloadSuggestModule(recentView)
        reloadSuggestModule(live3DView)
        reloadSuggestModule(favorite202207View)
        reloadSuggestModule(favorite202206View)
        reloadSuggestModule(historyView)
        reloadSuggestModule(favoriteView)
        
        // TODO: 汎用化して存在しないモジュールは表示できないようにしておきたい
        historyView.isHidden = Histories.shared.historyIds.count == 0
        favoriteView.isHidden = Favorites.shared.favoriteIds.count == 0
    }
    
    private func reloadSuggestModule(_ suggestModuleView: SuggestModuleView) {
        suggestModuleView.collectionView.setContentOffset(.zero, animated: false)
        suggestModuleView.collectionView.reloadData()
    }
    
    private func setupBackground() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
    }

    @objc func settingBarButtonTapped(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "Setting") as! SettingViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @objc func addPlayListBarButtonTapped(_ sender: UIBarButtonItem) {
        // displaySongsを更新しなくてはならない
        Songs.shared.resetDisplaySongs()
        
        let storyboard = UIStoryboard(name: "AddPlayList", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "AddPlayList") as! AddPlayListViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}


