//
//  ImageCaches.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/08/12.
//

import Foundation
import UIKit

final class ImageCaches {
    static var shared = ImageCaches()
    private init() {}
    
    // 最初にここを選択した後にfilteredを更新する処理を入れたい
    private(set) var caches: [String:UIImage] = [:]
    
    func setup() {
        guard Songs.shared.allSongs.count != 0 else {
            Logger.log(message: "allSongsがセットされていません")
            return
        }
        
        for song in Songs.shared.allSongs {
            let videoId = song.videoid
            if !caches.keys.contains(videoId) {
                let image = getImageByVideoId(videoId: videoId)
                caches.updateValue(image, forKey: videoId)
            }
        }
        
        for song in Songs.shared.favorite202206Songs {
            let videoId = song.videoid
            if !caches.keys.contains(videoId) {
                let image = getImageByVideoId(videoId: videoId)
                caches.updateValue(image, forKey: videoId)
            }
        }
        
        for song in Songs.shared.favorite202207Songs {
            let videoId = song.videoid
            if !caches.keys.contains(videoId) {
                let image = getImageByVideoId(videoId: videoId)
                caches.updateValue(image, forKey: videoId)
            }
        }
    }
    
    private func getImageByVideoId(videoId: String) -> UIImage {
        // let urlWithVideoId = "https://i.ytimg.com/vi/\(videoId)/default.jpg"
        let urlWithVideoId = "https://i.ytimg.com/vi/\(videoId)/mqdefault.jpg"
        let url = URL(string: urlWithVideoId)
        do {
            let data = try Data(contentsOf: url!)
            return UIImage(data: data)!
        } catch let err {
            print("Error : \(err.localizedDescription)")
            return UIImage(systemName: "xmark.circle.fill")!
        }
    }
}
