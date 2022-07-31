//
//  UIImage+.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/24.
//

import UIKit

extension UIImage {
    // 初期化時に行うとアプリ起動後は修正できない点は注意が必要
    // TODO: アプリ起動中にダークモード切り替えが起こった場合の対応
    // https://qiita.com/gonsee/items/c04b73787730c0e831df
    static func initWithDarkmode(systemName: String) -> UIImage? {
        if UITraitCollection.current.userInterfaceStyle == .dark {
            return UIImage(systemName: systemName)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        } else {
            return UIImage(systemName: systemName)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        }
    }
}
