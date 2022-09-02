//
//  UIImage+.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/24.
//

import UIKit

extension UIImage {
    // 白色のSFSymbolを取得する
    static func initWithTintColorWhite(systemName: String) -> UIImage? {
        return UIImage(systemName: systemName)?.withTintColor(.white, renderingMode: .alwaysOriginal)
    }
    
    // 横長画像の中心部を正方形にクロップする
    static func notFound() -> UIImage {
        return UIImage.initWithTintColorWhite(systemName: "xmark.circle.fill")!
    }
    
    // 4つの画像を合成する
    static func concatenateSquareImage(images: [UIImage]) -> UIImage {
        if images.count < 4 {
            return UIImage.notFound()
        }
        
        let imageW = images[0].size.width
        let imageH = images[0].size.height

        // 画像の下地を作成
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageW*2, height: imageH*2), false, 0)
        // 下地に画像を追加
        for (i, image) in images.enumerated() {
            let rect = CGRect(x: CGFloat((i/2))*imageW, y: CGFloat((i%2))*imageH, width: imageW, height: imageH)
            image.draw(in: rect)
        }
        // 合成後の画像を作成
        let concatenatedImage = UIGraphicsGetImageFromCurrentImageContext()!
        // 描画を終了
        UIGraphicsEndImageContext()
        return concatenatedImage
    }
    
    // 横長画像の中心部を正方形にクロップする
    func trimSquare() -> UIImage {
        let imageW = self.size.width
        let imageH = self.size.height
        let posX = (imageW - imageH) / 2
        let trimArea = CGRect(x: posX, y: 0, width: imageH, height: imageH)
        if let selfRef = self.cgImage, let tmp = selfRef.cropping(to: trimArea) {
            return UIImage(cgImage: tmp)
        }
        return UIImage(systemName: "xmark.circle.fill")!
    }

}
