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
    @IBOutlet weak var editPlayListView: UIStackView!
    @IBOutlet weak var editPlayListLabel: UILabel!
    
    var searchType: SearchType = .none
    var playListTitle: String?
    
    @IBOutlet weak var changeTitleButton: UIButton!
    @IBOutlet weak var addSongButton: UIButton!
    @IBOutlet weak var deletePlayListButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        songTableView.dataSource = self
        songTableView.delegate = self
        songTableView.register(UINib(nibName: "SongTableViewCell", bundle: nil), forCellReuseIdentifier: "SongTableViewCell")
        searchBar.delegate = self
        
        self.changeTitleButton.setImage(UIImage.initWithTintColorWhite(systemName: "pencil"), for: .normal)
        self.addSongButton.setImage(UIImage.initWithTintColorWhite(systemName: "plus"), for: .normal)
        self.deletePlayListButton.setImage(UIImage.initWithTintColorWhite(systemName: "trash"), for: .normal)
        
        if searchType != .addPlayList {
            editPlayListView.isHidden = true
        } else {
            if let title = playListTitle {
                editPlayListLabel.text = title
            }
        }
        
        setBackground()
        // searchBarは背景に画像がセットされているためこれを削除する
        searchBar.backgroundImage = UIImage()
    }
    
    @IBAction func tapChangeTitleButton(_ sender: Any) {
        presentChangeTitleAlert()
    }
    
    @IBAction func tapAddSongButton(_ sender: Any) {
        Logger.log(message: #function)
    }
    
    @IBAction func tapDeletePlayListButton(_ sender: Any) {
        deletePlayListAlert()
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

extension SearchViewController {
    private func presentChangeTitleAlert() {
        let alert = UIAlertController(title: "プレイリスト名の変更",
                                      message: "プレイリスト名を入力し変更ボタンを押してください",
                                      preferredStyle: .alert)

        // textFieldを追加
        var playListTitleTextField: UITextField?
        alert.addTextField(configurationHandler: {(textField) -> Void in
            playListTitleTextField = textField
            playListTitleTextField?.placeholder = self.playListTitle ?? ""
            }
        )

        // 実行ボタンを追加
        alert.addAction(UIAlertAction(title: "変更", style: .default, handler: {(action) -> Void in
            guard let newPlayListTitle = playListTitleTextField?.text else {
                self.presentCautionAlert(message: "プレイリスト名が取得できませんでした")
                return
            }
            
            guard !newPlayListTitle.isEmpty else {
                self.presentCautionAlert(message: "プレイリスト名を入力してください")
                return
            }
            
            guard !Songs.shared.playList.contains(newPlayListTitle) else {
                self.presentCautionAlert(message: "既に存在するプレイリスト名です")
                return
            }
            
            self.changeTitle(title: newPlayListTitle)
        }))
        
        // キャンセルボタンを追加
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        
        // AlertViewを表示
        self.present(alert, animated: true, completion: nil)
    }
    
    private func changeTitle(title: String) {
        PlayLists.shared.changePlayListTitle(playListTitle: self.playListTitle!, newPlayListTitle: title)
        Songs.shared.resetPlayListSongs()
        self.editPlayListLabel.text = title
    }
    
    private func deletePlayListAlert() {
        let alert = UIAlertController(title: "プレイリストの削除",
                                      message: "このプレイリストを削除しますか？",
                                      preferredStyle: .alert)

        // 実行ボタンを追加
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in
            self.removePlayList(title: self.playListTitle!)
        }))
        
        // キャンセルボタンを追加
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        
        // AlertViewを表示
        self.present(alert, animated: true, completion: nil)
    }
    
    private func removePlayList(title: String) {
        PlayLists.shared.removePlayList(playListTitle: playListTitle!)
        Songs.shared.resetPlayListSongs()
        self.navigationController?.popToRootViewController(animated: true)
    }

}

enum SearchType {
    case none
    case addPlayList
}

