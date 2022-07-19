//
//  GetSongFronJson.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/14.
//

import Foundation

struct GetSongFromJson {
    static func getSongs () -> [Song] {
        /// ①プロジェクト内にある"employees.json"ファイルのパス取得
        guard let url = Bundle.main.url(forResource: "suisei_song", withExtension: "json") else {
           fatalError("ファイルが見つからない")
        }

        /// ②employees.jsonの内容をData型プロパティに読み込み
        guard let data = try? Data(contentsOf: url) else {
           fatalError("ファイル読み込みエラー")
        }

        /// ③JSONデコード処理
        let decoder = JSONDecoder()
        guard let songs = try? decoder.decode([Song].self, from: data) else {
           fatalError("JSON読み込みエラー")
        }

        /// ④データ確認
        for song in songs {
            // あれ、これOptionalなのか
           print(song)
        }
        return songs
    }
}
