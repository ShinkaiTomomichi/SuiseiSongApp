//
//  FirstLaunchFlag.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/07/19.
//

import Foundation

struct FirstLAunchFlag {
    static var shared = FirstLAunchFlag()
    private init() {}
    
    var isFirstLaunch: Bool = true
}
