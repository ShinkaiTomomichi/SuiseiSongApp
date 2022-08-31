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
    private(set) var myFavoritesCaches: [String:UIImage] = [:]
    
    func setup() {
        setupThumbnails()
        setupHoloMemberIcons()
        setupMyFavoriteIcons()
    }
    
    private func setupThumbnails() {
        guard Songs.shared.allSongs.count != 0 else {
            Logger.log(message: "allSongsがセットされていません")
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
    
    private func getImage(byVideoId: String) -> UIImage {
        // let urlWithVideoId = "https://i.ytimg.com/vi/\(videoId)/default.jpg"
        let urlWithVideoId = "https://i.ytimg.com/vi/\(byVideoId)/mqdefault.jpg"
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
            let image = getImage(byUrl: elem.value)
            holomembersCaches.updateValue(image, forKey: elem.key)
        }
    }
    
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
    
    private func setupMyFavoriteIcons() {
        for myFavorite in Songs.shared.myFavorites {
            let image = getImage(byFavoriteName: myFavorite)
            myFavoritesCaches.updateValue(image, forKey: myFavorite)
        }
    }
    
    private func getImage(byFavoriteName: String) -> UIImage {
        // songsの中から画像を取得しランダムに合成
        if let songs = Songs.shared.myFavoriteSongs[byFavoriteName] {
            let videoIds = songs.map { $0.videoid }
            let uniqueVideoIds = videoIds.unique().shuffled()
            if uniqueVideoIds.count == 0 {
                return UIImage(systemName: "xmark.circle.fill")!
            } else if uniqueVideoIds.count == 1 {
                return getImage(byVideoId: videoIds[0]).cropSeihoukei()
            } else if uniqueVideoIds.count == 2 {
                return UIImage.montageFourSeihoukei(images: [getImage(byVideoId: uniqueVideoIds[0]).cropSeihoukei(), getImage(byVideoId: uniqueVideoIds[1]).cropSeihoukei(), getImage(byVideoId: uniqueVideoIds[1]).cropSeihoukei(), getImage(byVideoId: uniqueVideoIds[0]).cropSeihoukei()])
            } else if uniqueVideoIds.count == 3 {
                return UIImage.montageFourSeihoukei(images: [getImage(byVideoId: uniqueVideoIds[0]).cropSeihoukei(), getImage(byVideoId: uniqueVideoIds[1]).cropSeihoukei(), getImage(byVideoId: uniqueVideoIds[2]).cropSeihoukei(), getImage(byVideoId: uniqueVideoIds[0]).cropSeihoukei()])
            } else {
                return UIImage.montageFourSeihoukei(images: [getImage(byVideoId: uniqueVideoIds[0]).cropSeihoukei(), getImage(byVideoId: uniqueVideoIds[1]).cropSeihoukei(), getImage(byVideoId: uniqueVideoIds[2]).cropSeihoukei(), getImage(byVideoId: uniqueVideoIds[3]).cropSeihoukei()])
            }
        }
        return UIImage(systemName: "xmark.circle.fill")!
    }
}
