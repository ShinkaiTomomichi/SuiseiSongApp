//
//  UIImage+.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/24.
//

import UIKit

extension UIImage {
    static func initWithTintColorWhite(systemName: String) -> UIImage? {
        return UIImage(systemName: systemName)?.withTintColor(.white, renderingMode: .alwaysOriginal)
    }
}
