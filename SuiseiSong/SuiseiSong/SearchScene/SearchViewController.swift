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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        songTableView.dataSource = self
        songTableView.delegate = self
        songTableView.register(UINib(nibName: "SongTableViewCell", bundle: nil), forCellReuseIdentifier: "SongTableViewCell")
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Songs.shared.filteredSongs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableViewCell", for: indexPath) as! SongTableViewCell

        // セルに対応する歌をセット
        let index = indexPath.row
        cell.song = Songs.shared.filteredSongs[index]
        
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

// searchBarの検索機能を追加したい

