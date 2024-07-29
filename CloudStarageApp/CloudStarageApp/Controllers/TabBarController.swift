//
//  TabBarController.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 11.07.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    init(tabBarControllers: [UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        for tab in tabBarControllers {
            self.addChild(tab)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.itemPositioning = .centered
        
        tabBar.backgroundColor = .white
        tabBar.tintColor = AppColors.standartBlue
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = { UIColor.gray.withAlphaComponent(0.1).cgColor }()
        let shadowImage = UIImage(named: "tabBarShadow")
        tabBar.shadowImage = shadowImage
    }
    
    func finish() {
        self.tabBar.items?.removeAll()
    }
}
