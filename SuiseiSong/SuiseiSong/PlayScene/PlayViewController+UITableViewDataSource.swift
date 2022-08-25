//
//  ViewController+TableDelegate.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/23.
//

import UIKit

extension PlayViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Songs.shared.filteredSongs.count
    }
    
    // 推定の高さを指定することでパフォーマンス改善を測る
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableViewCell", for: indexPath) as! SongTableViewCell

        // セルに対応する歌をセット
        let index = indexPath.row
        cell.song = Songs.shared.filteredSongs[index]
        
        // cellの再利用で変な挙動になっている
        // cell.reloadSelected()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = self.songTableView.cellForRow(at: indexPath) as? SongTableViewCell {
            SelectedStatus.shared.setSelectedSong(song: cell.song!)
        }        
    }
}
