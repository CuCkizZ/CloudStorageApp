//
//  BaseViewControllerProtocol.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 12.08.2024.
//

import UIKit.UICollectionView

protocol BaseViewControllerProtocol {
    func logout()
    func reloadCollectionView(collectionView: UICollectionView)
}

protocol HomeViewControllerProtocol: BaseViewControllerProtocol {}
protocol StorageViewControllerProtocol: BaseViewControllerProtocol {}
protocol PublicStorageViewControllerProtocol: BaseViewControllerProtocol {}

