//
//  SearchViewController.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/24.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var recentView: SuggestModuleView!
    @IBOutlet weak var favoriteView: SuggestModuleView!
    @IBOutlet weak var historyView: SuggestModuleView!
    @IBOutlet weak var live3DView: SuggestModuleView!
    @IBOutlet weak var notStreamView: SuggestModuleView!
    @IBOutlet weak var myPlayListView: PlayListView!
    @IBOutlet weak var collabView: PlayListView!
    @IBOutlet weak var artistView: PlayListView!
    @IBOutlet weak var playListView: PlayListView!
    
    // NavigationBarに追加するボタン
    var settingBarButtonItem: UIBarButtonItem!
    var addPlayListBarButtonItem: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // モジュールによっては表示する度にシャッフルする
        Songs.shared.sortOtherSongs()
        reloadSuggestAndPlayListModule()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var checkTimer = CheckTimer()
        checkTimer.check(handler: {
            let nc = self.navigationController
            recentView.setup(title: "最近の動画", songs: Songs.shared.displaySongs, navigationController: nc)
            live3DView.setup(title: "3Dライブ", songs: Songs.shared.live3DSongs, navigationController: nc)
            historyView.setup(title: "履歴", songs: Songs.shared.historySongs, navigationController: nc)
            favoriteView.setup(title: "お気に入り", songs: Songs.shared.favoriteSongs, navigationController: nc)
            notStreamView.setup(title: "歌動画", songs: Songs.shared.notStreamSongs, navigationController: nc)
            collabView.setup(title: "コラボ",
                             keys: Songs.shared.holoMembers,
                             songs: Songs.shared.holoMembersSongs,
                             playListStyle: .collaboration,
                             navigationController: nc)
            artistView.setup(title: "アーティスト",
                             keys: Songs.shared.artists,
                             songs: Songs.shared.artistsSongs,
                             playListStyle: .artist,
                             navigationController: nc)
            myPlayListView.setup(title: "ホロライブおすすめ",
                                 keys: Songs.shared.myFavorites,
                                 songs: Songs.shared.myFavoriteSongs,
                                 playListStyle: .myFavorite,
                                 navigationController: nc)
            playListView.setup(title: "プレイリスト",
                               keys: Songs.shared.playList,
                               songs: Songs.shared.playListSongs,
                               playListStyle: .playList,
                               navigationController: nc)
            
            
            settingBarButtonItem = UIBarButtonItem(image: UIImage.initWithTintColorWhite(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(settingBarButtonTapped(_:)))
            addPlayListBarButtonItem = UIBarButtonItem(image: UIImage.initWithTintColorWhite(systemName: "plus"), style: .plain, target: self, action: #selector(addPlayListBarButtonTapped(_:)))
            
            self.navigationItem.rightBarButtonItems = [settingBarButtonItem, addPlayListBarButtonItem]
            
            // フリックを入れるとスライダーと相性が悪いので無効化
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            // NavigationBarの文字色を変更
            self.navigationController?.navigationBar.tintColor = .white
            
            setupBackground()
        }, comment: "viewDidLoad")
    }
    
    private func reloadSuggestAndPlayListModule() {
        resetScrollAndReload(recentView)
        resetScrollAndReload(live3DView)
        resetScrollAndReload(historyView)
        resetScrollAndReload(favoriteView)
        resetScrollAndReload(notStreamView)
        resetScrollAndReload(collabView)
        resetScrollAndReload(artistView)
        resetScrollAndReload(myPlayListView)
        resetScrollAndReload(playListView)
        
        // 順序が変わらないものは適用しない
        live3DView.resetSongs(songs: Songs.shared.live3DSongs)
        notStreamView.resetSongs(songs: Songs.shared.notStreamSongs)
        favoriteView.resetSongs(songs: Songs.shared.favoriteSongs)
        historyView.resetSongs(songs: Songs.shared.historySongs)
        playListView.resetSongs(playListSongs: Songs.shared.playListSongs)
        
        // TODO: 汎用化して存在しないモジュールは表示できないようにしておきたい
        playListView.isHidden = PlayLists.shared.playListIds.isEmpty
        historyView.isHidden = Histories.shared.historyIds.count == 0
        favoriteView.isHidden = Favorites.shared.favoriteIds.count == 0
    }
    
    private func resetScrollAndReload(_ suggestModuleView: SuggestModuleView) {
        suggestModuleView.collectionView.setContentOffset(.zero, animated: false)
        suggestModuleView.collectionView.reloadData()
    }
    
    private func resetScrollAndReload(_ playListView: PlayListView) {
        playListView.collectionView.setContentOffset(.zero, animated: false)
        playListView.collectionView.reloadData()
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


