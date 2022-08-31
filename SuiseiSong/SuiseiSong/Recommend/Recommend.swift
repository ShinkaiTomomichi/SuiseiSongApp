//
//  Recommend.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/08/26.
//

import Foundation

struct Recommend {
    static func randomize(songs: [Song]) -> [Int] {
        return songs.map { $0.id }.shuffled()
    }
    
    static func personalize(songs: [Song]) -> [Int] {
        // TODO: なんか履歴とかお気に入りを使っていい感じにする
        return songs.map { $0.id }.shuffled()
    }
}
