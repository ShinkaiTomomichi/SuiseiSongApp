//
//  GetSongFronJson.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/14.
//

import Foundation

// 今後DBに移行するため設計は雑で良い
// クラスなのに動詞から始まるのはどうなのか？
struct JSONFileManager {
    static func getSuiseiSongs (forResource: String) -> [Song] {
        /// ①プロジェクト内にある"employees.json"ファイルのパス取得
        guard let url = Bundle.main.url(forResource: forResource, withExtension: "json") else {
           fatalError("ファイルが見つからない")
        }

        /// ②employees.jsonの内容をData型プロパティに読み込み
        guard let data = try? Data(contentsOf: url) else {
           fatalError("ファイル読み込みエラー")
        }

        /// ③JSONデコード処理
        let decoder = JSONDecoder()
        var songsForJSON: [SongForJSON] = []
        do {
            songsForJSON = try decoder.decode([SongForJSON].self, from: data)
        } catch {
            print(error)
            print(error.localizedDescription)
            fatalError("JSON読み込みエラー")
        }
        
        let songs = translateSongs(songsForJSON)
        
        return songs
    }
    
    private static func translateSongs(_ songsForJSON: [SongForJSON]) -> [Song] {
        var songs: [Song] = []
        for songForJSON in songsForJSON {
            songs.append(Song.init(songForJSON: songForJSON))
        }
        return songs
    }
}
