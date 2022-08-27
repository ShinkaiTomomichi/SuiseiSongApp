//
//  AddPlayListViewController.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/08/26.
//

import UIKit

class AddPlayListViewController: UIViewController {

    @IBOutlet weak var playListTitleTextField: UITextField!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var songTableView: UITableView!
    
    // NavigationBarに追加するボタン
    var shareBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        songTableView.dataSource = self
        songTableView.delegate = self
        songTableView.register(UINib(nibName: "SongTableViewCell", bundle: nil), forCellReuseIdentifier: "SongTableViewCell")
        searchBar.delegate = self
        
        shareBarButtonItem = UIBarButtonItem(image: UIImage.initWithTintColorWhite(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareBarButtonTapped(_:)))
        
        self.navigationItem.rightBarButtonItems = [shareBarButtonItem]
    }
    
    @objc func shareBarButtonTapped(_ sender: UIBarButtonItem) {
        Logger.log(message: "")
    }
}

extension AddPlayListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Songs.shared.displaySongsForSearch.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableViewCell", for: indexPath) as! SongTableViewCell

        // セルに対応する歌をセット
        let index = indexPath.row
        cell.song = Songs.shared.displaySongsForSearch[index]
        
        return cell
    }
}

extension AddPlayListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // キーボードを閉じる
        view.endEditing(true)
        
        if let searchText = searchBar.text {
            Songs.shared.setDisplaySongsForSearch(by: searchText)
            songTableView.setContentOffset(.zero, animated: false)
            songTableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text {
            Songs.shared.setDisplaySongsForSearch(by: searchText)
            songTableView.setContentOffset(.zero, animated: false)
            songTableView.reloadData()
        }
    }
}
