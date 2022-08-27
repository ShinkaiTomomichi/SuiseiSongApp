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
    
    var playListIds: [Int] = []
    
    // NavigationBarに追加するボタン
    var saveBarButtonItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        songTableView.dataSource = self
        songTableView.delegate = self
        songTableView.register(UINib(nibName: "SongTableViewForChoiceCell", bundle: nil), forCellReuseIdentifier: "SongTableViewForChoiceCell")
        searchBar.delegate = self
        
        saveBarButtonItem = UIBarButtonItem(image: UIImage.initWithTintColorWhite(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(saveBarButtonTapped(_:)))
        
        self.navigationItem.rightBarButtonItems = [saveBarButtonItem]
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
            
            guard let title = playListTitleTextField?.text, !title.isEmpty else {
                self.presentCautionAlert(message: "プレイリスト名が不正です")
                return
            }
            
            guard Songs.shared.allSongs.filter({ $0.choice }).count != 0 else {
                self.presentCautionAlert(message: "プレイリストに追加する曲を選択してください")
                return
            }
            
            // TODO: プレイリスト名が重複する場合も気をつけたい
            self.savePlayList(title: title)
        }))
        
        // キャンセルボタンを追加
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        
        // AlertViewを表示
        self.present(alert, animated: true, completion: nil)
    }
    
    private func presentCautionAlert(message: String) {
        let alert = UIAlertController(title: "不正な入力です",
                                      message: message,
                                      preferredStyle: .alert)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func savePlayList(title: String) {
        Logger.log(message: "ここでUDに保存")
        self.navigationController?.popToRootViewController(animated: true)
    }
}

enum SortType {
    case recent
    case history
}
