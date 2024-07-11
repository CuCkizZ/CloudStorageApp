//
//  StorageCoordinator.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 11.07.2024.
//

import UIKit

final class StorageCoordinator: Coorditator {
    
    override func start() {
        let vc = ViewController()
        vc.view.backgroundColor = AppColors.storagePink
        navigationController?.pushViewController(vc, animated: true)
        
    }
    override func finish() {
        print("Im done")
    }
}
