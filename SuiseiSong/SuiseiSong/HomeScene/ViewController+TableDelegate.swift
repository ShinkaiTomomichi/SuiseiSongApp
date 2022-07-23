//
//  ViewController+TableDelegate.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/23.
//

import UIKit

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // あれdidSetってsharedにアクセスし終わっている訳ではないのか...
        return Songs.shared.filteredSongs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: SongTableCell = tableView.dequeueReusableCell(withIdentifier: "SongTableCell", for: indexPath) as! SongTableCell

        // セルに対応する歌をセット
        cell.song = Songs.shared.filteredSongs[indexPath.row]
        
        return cell
    }
}
