//
//  SettingViewController.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/08/05.
//

import UIKit

class SettingViewController: UIViewController {
    // 単純なリンクや処理が共通するなら問題ないが、そうでない場合はtableではない方が良いかも
    @IBOutlet weak var settingTableView: UITableView!
    let settingContents = ["リンク", "クレジット", "など"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingTableView.dataSource = self
        settingTableView.delegate = self
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingContents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath)

        // セルに対応する歌をセット
        let index = indexPath.row
        // TODO: textLabelはDeprecatedであるため修正
        cell.textLabel?.text = settingContents[index]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Logger.log(message: "各設定項目は未設定です")
    }
}
