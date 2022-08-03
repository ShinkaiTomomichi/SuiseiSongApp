//
//  File.swift
//  SuiseiSong
//
//  Created by shinkaitomomichi on 2022/08/03.
//

import UIKit

protocol SuggestModuleViewDelegateProtocol: UICollectionViewDelegate, UICollectionViewDataSource {
    var navigationController: UINavigationController? { get set }
    var filterCompletion: (() -> Void)? { get set }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}
