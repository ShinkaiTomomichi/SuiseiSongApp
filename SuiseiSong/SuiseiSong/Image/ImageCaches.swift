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
    
    private(set) var thumbnailCaches: [String:UIImage] = [:]
    private(set) var holoMembersCaches: [String:UIImage] = [:]
    private(set) var artistCaches: [String:UIImage] = [:]
    private(set) var myFavoritesCaches: [String:UIImage] = [:]
    // playListの画像は変更するので都度更新を入れたい
    private(set) var playListCaches: [String:UIImage] = [:]
        
    // imageCacheが無いリストは作らないようにしたが処理の順番が難しい...
    private let holoMemberImages: [ImageURL] = JSONFileManager.getImageURLs(forResource: "members")
    private let artistImages: [ImageURL] = JSONFileManager.getImageURLs(forResource: "artists")
    
    // YoutubeのvideoIDからサムネイル画像を取得
    private func getImage(byVideoId: String, quority: Quority = .medium) -> UIImage {
        switch (quority) {
        case .high:
            return getImage(byUrl: "https://i.ytimg.com/vi/\(byVideoId)/hqdefault.jpg")
        case .medium:
            return getImage(byUrl: "https://i.ytimg.com/vi/\(byVideoId)/mqdefault.jpg")
        case .low:
            return getImage(byUrl: "https://i.ytimg.com/vi/\(byVideoId)/default.jpg")
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
            return UIImage.notFound()
        }
    }
    
    // TODO: cellを更新する際に明らかに重いため改善する
    // 最悪一枚にすれば軽くなるがバックで非同期で回す処理が一番無難
    private func getImage(bySongs: [Song], shuffle: Bool) -> UIImage {
        // songsの中から画像を取得し4枚まで合成
        let videoIds = bySongs.map { $0.videoid }
        var uniqueVideoIds = videoIds.unique()
        if shuffle {
            uniqueVideoIds.shuffle()
        }
        if uniqueVideoIds.count == 0 {
            return UIImage.notFound()
        } else if uniqueVideoIds.count == 1 {
            return getImage(byVideoId: videoIds[0]).trimSquare()
        } else if uniqueVideoIds.count == 2 {
            return UIImage.concatenateSquareImage(images: [getImage(byVideoId: uniqueVideoIds[0]).trimSquare(),
                                                           getImage(byVideoId: uniqueVideoIds[1]).trimSquare(),
                                                           getImage(byVideoId: uniqueVideoIds[1]).trimSquare(),
                                                           getImage(byVideoId: uniqueVideoIds[0]).trimSquare()])
        } else if uniqueVideoIds.count == 3 {
            return UIImage.concatenateSquareImage(images: [getImage(byVideoId: uniqueVideoIds[0]).trimSquare(),
                                                           getImage(byVideoId: uniqueVideoIds[1]).trimSquare(),
                                                           getImage(byVideoId: uniqueVideoIds[2]).trimSquare(),
                                                           getImage(byVideoId: uniqueVideoIds[0]).trimSquare()])
        } else {
            return UIImage.concatenateSquareImage(images: [getImage(byVideoId: uniqueVideoIds[0]).trimSquare(),
                                                           getImage(byVideoId: uniqueVideoIds[1]).trimSquare(),
                                                           getImage(byVideoId: uniqueVideoIds[2]).trimSquare(),
                                                           getImage(byVideoId: uniqueVideoIds[3]).trimSquare()])
        }
    }
    
    func getImageThumbnail(byVideoId: String) -> UIImage {
        if let image = thumbnailCaches[byVideoId] {
            return image
        } else {
            // let url = "https://i.ytimg.com/vi/\(videoId)/default.jpg"
            let url = "https://i.ytimg.com/vi/\(byVideoId)/mqdefault.jpg"
            let image = getImage(byUrl: url)
            thumbnailCaches.updateValue(image, forKey: byVideoId)
            return image
        }
    }
        
    func getImageHoloMemberIcon(byName: String) -> UIImage {
        if let image = holoMembersCaches[byName] {
            return image
        } else {
            if let url = ImageURL.getUrl(byName: byName, imageURLs: holoMemberImages) {
                let image = getImage(byUrl: url)
                holoMembersCaches.updateValue(image, forKey: byName)
                return image
            } else {
                let image = UIImage.notFound()
                holoMembersCaches.updateValue(image, forKey: byName)
                return image
            }
        }
    }
    
    func getImageArtistIcon(byName: String) -> UIImage {
        if let image = artistCaches[byName] {
            return image
        } else {
            if let url = ImageURL.getUrl(byName: byName, imageURLs: artistImages) {
                let image = getImage(byUrl: url)
                artistCaches.updateValue(image, forKey: byName)
                return image
            } else {
                let image = UIImage.notFound()
                artistCaches.updateValue(image, forKey: byName)
                return image
            }
        }
    }
    
    func getImageMyFavorites(byTitle: String) -> UIImage {
        if let image = myFavoritesCaches[byTitle] {
            return image
        } else {
            if let songs = Songs.shared.myFavoriteSongs[byTitle] {
                let image = getImage(bySongs: songs, shuffle: true)
                myFavoritesCaches.updateValue(image, forKey: byTitle)
                return image
            } else {
                let image = UIImage.notFound()
                myFavoritesCaches.updateValue(image, forKey: byTitle)
                return image
            }
        }
    }
    
    func getImagePlayListIcon(byTitle: String) -> UIImage {
        if let image = playListCaches[byTitle] {
            return image
        } else {
            if let songs = Songs.shared.playListSongs[byTitle] {
                let image = getImage(bySongs: songs, shuffle: false)
                playListCaches.updateValue(image, forKey: byTitle)
                return image
            } else {
                let image = UIImage.notFound()
                playListCaches.updateValue(image, forKey: byTitle)
                return image
            }
        }
    }
    
    func removeImagePlayListIcon() {
        playListCaches.removeAll()
    }
}

enum Quority {
    case high
    case medium
    case low
}
