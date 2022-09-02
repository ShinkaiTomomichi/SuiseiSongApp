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
    static func getSongs(forResource: String) -> [Song] {
        // JSONファイルのパスを指定
        guard let url = Bundle.main.url(forResource: forResource, withExtension: "json") else {
           fatalError("ファイルが見つからない")
        }
        // Data型として取得
        guard let data = try? Data(contentsOf: url) else {
           fatalError("ファイル読み込みエラー")
        }
        // デコード
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
    
    // ArrayなどCodableではない要素を扱うために変換をかませている
    private static func translateSongs(_ songsForJSON: [SongForJSON]) -> [Song] {
        var songs: [Song] = []
        for songForJSON in songsForJSON {
            songs.append(Song.init(songForJSON: songForJSON))
        }
        return songs
    }
    
    static func getImageURLs(forResource: String) -> [ImageURL] {
        // JSONファイルのパスを指定
        guard let url = Bundle.main.url(forResource: forResource, withExtension: "json") else {
           fatalError("ファイルが見つからない")
        }
        // Data型として取得
        guard let data = try? Data(contentsOf: url) else {
           fatalError("ファイル読み込みエラー")
        }
        // デコード
        let decoder = JSONDecoder()
        var imageURLs: [ImageURL] = []
        do {
            imageURLs = try decoder.decode([ImageURL].self, from: data)
        } catch {
            print(error)
            print(error.localizedDescription)
            fatalError("JSON読み込みエラー")
        }        
        return imageURLs
    }

}
