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
    
    private(set) var caches: [String:UIImage] = [:]
    private(set) var holoMembersCaches: [String:UIImage] = [:]
    private(set) var myFavoritesCaches: [String:UIImage] = [:]
    // playListの画像は変更するので都度更新を入れたい
    private(set) var playListCaches: [String:UIImage] = [:]
    
    func setup() {
        setupThumbnails()
        setupHoloMemberIcons()
        setupMyFavoriteIcons()
        // 以下は可変性であるため更新が必要
        setupPlayListIcons()
    }
    
    private func setupThumbnails() {
        guard Songs.shared.allSongs.count != 0 else {
            Logger.log(message: "1曲も動画がセットできませんでした")
            return
        }
        
        for song in Songs.shared.allSongs {
            let videoId = song.videoid
            if !caches.keys.contains(videoId) {
                let image = getImage(byVideoId: videoId)
                caches.updateValue(image, forKey: videoId)
            }
        }
    }
    
    // imageCacheが無いリストは作らないようにしたが処理の順番が難しい...
    private let holoMembersImages: [String:String] = ["天音かなた":"https://yt3.ggpht.com/TlH8nz5O9UYo5JZ_5fo4JfXdT18N0Ck27wWrulni-c1g5bwes0tVmFiSKICzI1SW7itaTkk9GA=s240-c-k-c0x00ffffff-no-rj",
                                              "常闇トワ":"https://yt3.ggpht.com/meRnxbRUm5yPSwq8Q5QpI5maFApm5QTGQV_LGblQFsoO0yAV4LI-nSZ70GYwMZ_tbfSa_O8MTCU=s240-c-k-c0x00ffffff-no-rj",
                                              "桃鈴ねね":"https://yt3.ggpht.com/bMBMxmB1YVDVazU-8KbB6JZqUHn4YzmFiQRWwEUHCeqm5REPW7HHQChC5xE6e36aqqnXgK4a=s240-c-k-c0x00ffffff-no-rj",
                                              "宝鐘マリン":"https://yt3.ggpht.com/ytc/AMLnZu8CxDCEDrsPl0qLatamE8oCa-gOVwJgyBK8kn0RsA=s240-c-k-c0x00ffffff-no-rj",
                                              "湊あくあ":"https://yt3.ggpht.com/ytc/AMLnZu-V1kC8vBXkZ8owy3xQ4k3C7vnkXHqGP1RFEyvu0g=s240-c-k-c0x00ffffff-no-rj"]
    
    private func setupHoloMemberIcons() {
        for elem in holoMembersImages {
            let image = getImage(byUrl: elem.value)
            holoMembersCaches.updateValue(image, forKey: elem.key)
        }
    }
    
    private func setupMyFavoriteIcons() {
        for myFavorite in Songs.shared.myFavorites {
            if let songs = Songs.shared.myFavoriteSongs[myFavorite] {
                let image = getImage(bySongs: songs)
                myFavoritesCaches.updateValue(image, forKey: myFavorite)
            }
        }
    }
    
    private func setupPlayListIcons() {
        for title in Songs.shared.playList {
            if let songs = Songs.shared.playListSongs[title] {
                let image = getImage(bySongs: songs, shuffle: false)
                playListCaches.updateValue(image, forKey: title)
            }
        }
    }
    
    // URLから画像を取得
    private func getImage(byUrl: String) -> UIImage {
        let url = URL(string: byUrl)
        do {
            let data = try Data(contentsOf: url!)
            return UIImage(data: data)!
        } catch let err {
            print("Error : \(err.localizedDescription)")
            return UIImage(systemName: "xmark.circle.fill")!
        }
    }
    
    // YoutubeのvideoIDからサムネイル画像を取得
    private func getImage(byVideoId: String) -> UIImage {
        // let urlWithVideoId = "https://i.ytimg.com/vi/\(videoId)/default.jpg"
        let urlWithVideoId = "https://i.ytimg.com/vi/\(byVideoId)/mqdefault.jpg"
        return getImage(byUrl: urlWithVideoId)
    }
    
    private func getImage(bySongs: [Song], shuffle: Bool = true) -> UIImage {
        // songsの中から画像を取得し4枚まで合成
        let videoIds = bySongs.map { $0.videoid }
        var uniqueVideoIds = videoIds.unique()
        if shuffle {
            uniqueVideoIds.shuffle()
        }
        if uniqueVideoIds.count == 0 {
            return UIImage(systemName: "xmark.circle.fill")!
        } else if uniqueVideoIds.count == 1 {
            return getImage(byVideoId: videoIds[0]).trimSquare()
        } else if uniqueVideoIds.count == 2 {
            return UIImage.concatenateSquareImage(images: [getImage(byVideoId: uniqueVideoIds[0]).trimSquare(), getImage(byVideoId: uniqueVideoIds[1]).trimSquare(), getImage(byVideoId: uniqueVideoIds[1]).trimSquare(), getImage(byVideoId: uniqueVideoIds[0]).trimSquare()])
        } else if uniqueVideoIds.count == 3 {
            return UIImage.concatenateSquareImage(images: [getImage(byVideoId: uniqueVideoIds[0]).trimSquare(), getImage(byVideoId: uniqueVideoIds[1]).trimSquare(), getImage(byVideoId: uniqueVideoIds[2]).trimSquare(), getImage(byVideoId: uniqueVideoIds[0]).trimSquare()])
        } else {
            return UIImage.concatenateSquareImage(images: [getImage(byVideoId: uniqueVideoIds[0]).trimSquare(), getImage(byVideoId: uniqueVideoIds[1]).trimSquare(), getImage(byVideoId: uniqueVideoIds[2]).trimSquare(), getImage(byVideoId: uniqueVideoIds[3]).trimSquare()])
        }
    }
}
