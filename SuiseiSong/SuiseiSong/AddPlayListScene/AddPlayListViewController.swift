//
//  AddPlayListViewController.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/08/26.
//

import UIKit

class AddPlayListViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var songTableView: UITableView!
    
    var playListTitle: String?
    var playListIds: [Int] = []
    
    // NavigationBarに追加するボタン
    var saveBarButtonItem: UIBarButtonItem!
    var updateBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Songs.shared.setupChoicies(playListIds: playListIds)

        songTableView.dataSource = self
        songTableView.delegate = self
        songTableView.register(UINib(nibName: "SongTableViewForChoiceCell", bundle: nil), forCellReuseIdentifier: "SongTableViewForChoiceCell")
        searchBar.delegate = self
        
        saveBarButtonItem = UIBarButtonItem(title: "次へ", style: .done, target: self, action: #selector(saveBarButtonTapped(_:)))
        updateBarButtonItem = UIBarButtonItem(title: "更新", style: .done, target: self, action: #selector(updateBarButtonTapped(_:)))
        if playListIds.count == 0 && playListTitle == nil {
            self.navigationItem.rightBarButtonItems = [saveBarButtonItem]
        } else {
            self.navigationItem.rightBarButtonItems = [updateBarButtonItem]
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        Songs.shared.resetChoicies()
    }
    
    @IBAction func tapSortButton(_ sender: Any) {
        // sort形式をtoggleする
        // displaySongsを再セットするとかか?
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongTableViewForChoiceCell", for: indexPath) as! SongTableViewForChoiceCell

        // セルに対応する歌をセット
        let index = indexPath.row
        cell.song = Songs.shared.displaySongsForSearch[index]
        cell.vc = self
        
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

// 保存ボタンに関するextension
extension AddPlayListViewController {
    @objc func saveBarButtonTapped(_ sender: UIBarButtonItem) {
        presentSaveAlert()
    }
    
    private func presentSaveAlert() {
        let alert = UIAlertController(title: "新しいプレイリスト",
                                      message: "プレイリスト名を入力し保存ボタンを押してください",
                                      preferredStyle: .alert)

        // textFieldを追加
        var playListTitleTextField: UITextField?
        alert.addTextField(configurationHandler: {(textField) -> Void in
            playListTitleTextField = textField
            playListTitleTextField?.placeholder = "プレイリスト名"
            }
        )

        // 実行ボタンを追加
        alert.addAction(UIAlertAction(title: "保存", style: .default, handler: {(action) -> Void in
            guard let playListTitle = playListTitleTextField?.text else {
                self.presentCautionAlert(message: "プレイリスト名が取得できませんでした")
                return
            }
            
            guard !playListTitle.isEmpty else {
                self.presentCautionAlert(message: "プレイリスト名を入力してください")
                return
            }

            guard Songs.shared.allSongs.filter({ $0.choice }).count != 0 else {
                self.presentCautionAlert(message: "プレイリストに追加する曲を選択してください")
                return
            }
            
            guard !Songs.shared.playList.contains(playListTitle) else {
                self.presentCautionAlert(message: "既に存在するプレイリスト名です")
                return
            }
            
            self.savePlayList(title: playListTitle)
        }))
        
        // キャンセルボタンを追加
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        
        // AlertViewを表示
        self.present(alert, animated: true, completion: nil)
    }
        
    private func savePlayList(title: String) {
        Logger.log(message: playListIds)
        PlayLists.shared.setPlayListIds(playListTitle: title, songIds: playListIds)
        Songs.shared.resetPlayListSongs()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func updateBarButtonTapped(_ sender: UIBarButtonItem) {
        presentUpdateAlert()
    }
    
    private func presentUpdateAlert() {
        let alert = UIAlertController(title: "プレイリストの更新",
                                      message: "プレイリストを更新しますか？",
                                      preferredStyle: .alert)

        // 実行ボタンを追加
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) -> Void in

            guard Songs.shared.allSongs.filter({ $0.choice }).count != 0 else {
                self.presentCautionAlert(message: "プレイリストに追加する曲を選択してください")
                return
            }
            
            if let playListTitle = self.playListTitle {
                self.savePlayList(title: playListTitle)
            } else {
                Logger.log(message: "playListTitleがセットされていません")
            }
        }))
        
        // キャンセルボタンを追加
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        
        // AlertViewを表示
        self.present(alert, animated: true, completion: nil)
    }

}

enum SortType {
    case recent
    case history
}
