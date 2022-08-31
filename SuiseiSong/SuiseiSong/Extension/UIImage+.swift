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
    
    // 横長の画像を正方形にクロップする
    func cropSeihoukei() -> UIImage {
        let imageW = self.size.width
        let imageH = self.size.height
        let posX = (imageW - imageH) / 2
        let trimArea = CGRect(x: posX, y: 0, width: imageH, height: imageH)
        if let selfRef = self.cgImage, let tmp = selfRef.cropping(to: trimArea) {
            return UIImage(cgImage: tmp)
        }
        return UIImage(systemName: "xmark.circle.fill")!
    }
    
    // 4つの画像を合成する
    static func montageFourSeihoukei(images: [UIImage]) -> UIImage {
        if images.count < 4 {
            return UIImage(systemName: "xmark.circle.fill")!
        }
        
        let imageW = images[0].size.width
        let imageH = images[0].size.height

        //画像の下地をサイズを指定して作成
        UIGraphicsBeginImageContextWithOptions(CGSize(width: imageW*2, height: imageH*2), false, 0)
        
        for (i, image) in images.enumerated() {
            let rect = CGRect(x: CGFloat((i/2))*imageW, y: CGFloat((i%2))*imageH, width: imageW, height: imageH)
            image.draw(in: rect)
        }
           
        //カレンダーに表示する画像の生成
        let calendarImage = UIGraphicsGetImageFromCurrentImageContext()
           
        //描画を終了
        UIGraphicsEndImageContext()
        return calendarImage!
    }
}
