//
//  ViewController+TableDelegate.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/23.
//

import UIKit

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Songs.shared.filteredSongs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableCell", for: indexPath) as! SongTableCell

        // セルに対応する歌をセット
        let index = indexPath.row
        cell.song = Songs.shared.filteredSongs[index]
        cell.index = index
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = self.songTableView.cellForRow(at: indexPath) as? SongTableCell {
            SelectedStatus.shared.setSelectedSong(song: cell.song!)
        }        
    }
}
