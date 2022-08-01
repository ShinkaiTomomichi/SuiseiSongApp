//
//  SearchViewController.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/24.
//

import UIKit

class SearchViewController: UIViewController {
    // table表示で設定項目を追加する
    // 以下みたいにするとむしろホーム画面みたいになるのか？
    // 一旦ホーム画面みたいな構成でやってみるのも面白いかも
    // 画面構成を変えるかはどのようなデータが取れるかに依存するため一旦分析の方を進めてもいいかもしれん
    // 確かに現状聞こうにも探し方が難しすぎる
    
    // 一覧へGO、お気に入り、履歴、ライブ、オリジナル曲、コラボ、くらいのジャンル分け
    // おすすめの動画作成（履歴がないとどうにもならないがmockを用意しておく）
    // アーティストで絞り込む 3つくらい候補 & 詳しくみる（Artistの画像って取得可能か？）
    // コラボ相手で絞り込む 3つくらい候補 & 詳しくみる
    // ジャンルで絞り込む 3つくらい候補 & 詳しくみる（最悪上と合わせてもいいかもしれない）
    
    // こちらをスタート画面にしてタップした時にその情報をYTのシングルトンに渡して起動する？
    // その場合検索とかの動線はどうしようか？そのまま行くとリセットになる
    
    // 複数のViewを出してScrollViewにsiteokitai
    
    // collectionViewの親クラスを作った方が使いやすそう
    @IBOutlet weak var suggestCollectionView: UICollectionView!
    @IBOutlet weak var monthlyCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Songsと密結合になりすぎてえらいことになってる
        // この辺りの挙動は一通り導線を見直す必要がある
        Songs.shared.setup()
        
        // NavigationBarのタイトル
        self.title = "すいちゃんのうた"
        
        // このようなテーブルを複製する場合どのようにモジュール化するのがベストか???
        suggestCollectionView.delegate = self
        suggestCollectionView.dataSource = self
        
        // delegateの中身が完全に呼ばれていないのは何故?
        monthlyCollectionView.delegate = self
        monthlyCollectionView.dataSource = self
        
        // suggestCollectionViewを複製してどのような挙動になるかを確認
        
        // UXが低いので一旦無効化
        // TODO: ユーザの直感には反するため、改善策を検討
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}

// Delegateをselfにすると複数のTableに対応出来なくなるのか
//
// tagを使って利用する方法もあるがあまり綺麗じゃない気がする...
// tapする時にHome画面に移動する
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // セルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == suggestCollectionView{
            return 5
        } else {
            return Songs.shared.favoriteSongs.count
        }
    }
    
    // セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //storyboard上のセルを生成　storyboardのIdentifierで付けたものをここで設定する
        var cell: SuggestCollectionCell
        let index = indexPath.row
        if collectionView == suggestCollectionView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "suggestCell", for: indexPath) as! SuggestCollectionCell
            cell.song = Songs.shared.allSongs[index]
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "monthlyCell", for: indexPath) as! SuggestCollectionCell
            cell.song = Songs.shared.favoriteSongs[index]
        }

        return cell
    }
    
    // セルの間隔
    private func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimunLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // セルタップ時
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Logger.log(message: "タップされました")
        
        let storyboard = UIStoryboard(name: "Play", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(withIdentifier: "Play") as! ViewController
        // フルスクリーンにすると戻せなくなるので
        // nextViewController.modalPresentationStyle = .fullScreen
        // self.present(nextViewController, animated: true, completion: nil)
        
        // 今のセルを取り出したい
        // 強制アンラップが雑なので後で直す
        if collectionView == suggestCollectionView {
            if let cell = self.suggestCollectionView.cellForItem(at: indexPath) as? SuggestCollectionCell {
                SelectedStatus.shared.setSelectedSong(song: cell.song!, filterCompletion: {
                    Songs.shared.reset()
                })
            }
        } else {
            if let cell = self.monthlyCollectionView.cellForItem(at: indexPath) as? SuggestCollectionCell {
                SelectedStatus.shared.setSelectedSong(song: cell.song!, filterCompletion: {
                    Songs.shared.setFavorite()
                })
            }
        }
        
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
        // 2回目の表示の時にWebViewがloadされていない
        // 単純に2回呼ばれる想定じゃないからloadが入らなくなってるっぽい
        // selectedVideoのIDが変わらないため、これは終了時に消せばいけそうだが
    }
}
