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
    private(set) var holomembersCaches: [String:UIImage] = [:]
    
    func setup() {
        setupThumbnails()
        setupHoloMemberIcons()
    }
    
    private func setupThumbnails() {
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
    
    private let holomembersImages: [String:String] = ["天音かなた":"https://yt3.ggpht.com/TlH8nz5O9UYo5JZ_5fo4JfXdT18N0Ck27wWrulni-c1g5bwes0tVmFiSKICzI1SW7itaTkk9GA=s240-c-k-c0x00ffffff-no-rj",
                                              "常闇トワ":"https://yt3.ggpht.com/meRnxbRUm5yPSwq8Q5QpI5maFApm5QTGQV_LGblQFsoO0yAV4LI-nSZ70GYwMZ_tbfSa_O8MTCU=s240-c-k-c0x00ffffff-no-rj",
                                              "桃鈴ねね":"https://yt3.ggpht.com/bMBMxmB1YVDVazU-8KbB6JZqUHn4YzmFiQRWwEUHCeqm5REPW7HHQChC5xE6e36aqqnXgK4a=s240-c-k-c0x00ffffff-no-rj",
                                              "宝鐘マリン":"https://yt3.ggpht.com/ytc/AMLnZu8CxDCEDrsPl0qLatamE8oCa-gOVwJgyBK8kn0RsA=s240-c-k-c0x00ffffff-no-rj",
                                              "湊あくあ":"https://yt3.ggpht.com/ytc/AMLnZu-V1kC8vBXkZ8owy3xQ4k3C7vnkXHqGP1RFEyvu0g=s240-c-k-c0x00ffffff-no-rj"]
    
    private func setupHoloMemberIcons() {
        for elem in holomembersImages {
            let image = getImageByVideoId(url: elem.value)
            holomembersCaches.updateValue(image, forKey: elem.key)
        }
    }
    
    private func getImageByVideoId(url: String) -> UIImage {
        let urlWithVideoId = url
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
