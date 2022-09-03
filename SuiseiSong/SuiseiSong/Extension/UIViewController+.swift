//
//  UIViewController+.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/09/03.
//

import UIKit

extension UIViewController {
    func setBackground() {
        self.view.backgroundColor = UIColor(patternImage: UIImage.background())
    }
    
    func presentCautionAlert(title: String = "不正な入力です", message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
    
