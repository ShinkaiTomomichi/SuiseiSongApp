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
    
    @IBOutlet weak var recentView: SuggestModuleView!
    @IBOutlet weak var favorite202207View: SuggestModuleView!
    @IBOutlet weak var favorite202206View: SuggestModuleView!
    
    // NavigationBarに追加するボタン
    var settingBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Songs.shared.setup()
        
        // NavigationBarのタイトル
        // ここは画像などに差し替えた方が良さそう
        self.title = "すいちゃんのうた"
                
        // 煩雑なので効率化したい
        recentView.setNavigationController(self.navigationController)
        favorite202207View.setNavigationController(self.navigationController)
        favorite202206View.setNavigationController(self.navigationController)

        settingBarButtonItem = UIBarButtonItem(image: UIImage.initWithDarkmode(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(settingBarButtonTapped(_:)))
        
        self.navigationItem.rightBarButtonItems = [settingBarButtonItem]
        
        // UXが低いので一旦無効化、TODO: ユーザの直感には反するため、改善策を検討
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    @objc func settingBarButtonTapped(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Setting", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "Setting") as! SettingViewController
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
}


