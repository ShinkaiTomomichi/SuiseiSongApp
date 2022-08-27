//
//  ListViewController.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/08/02.
//

import UIKit

// 検索のためにcellをnibファイルにして共通化する
class SearchViewController: UIViewController {
    @IBOutlet weak var songTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        songTableView.dataSource = self
        songTableView.delegate = self
        songTableView.register(UINib(nibName: "SongTableViewCell", bundle: nil), forCellReuseIdentifier: "SongTableViewCell")
        searchBar.delegate = self
        
        setupBackground()
    }
    
    private func setupBackground() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        // searchBarは背景に画像がセットされているためこれを削除する
        searchBar.backgroundImage = UIImage()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = self.songTableView.cellForRow(at: indexPath) as? SongTableViewCell {
            SelectedStatus.shared.setSelectedSong(song: cell.song!)
        }
        
        let storyboard = UIStoryboard(name: "Play", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "Play") as! PlayViewController
        
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate {
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

