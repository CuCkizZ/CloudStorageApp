//
//  TabBarController.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 11.07.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    weak var tabBarControllers: TabBarController?
    
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

extension UINavigationController {
    func setRightButton() -> UIBarButtonItem {
        return UIBarButtonItem(image: .profileTab, style: .plain, target: self, action: #selector(logout))
    }
    
    @objc func logout() {
        let coordinator: CoordinatorProtocol = Coordinator(type: .logout, navigationController: self)
        let alert = UIAlertController(title: "Log out", message: "Are you sure?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            print("Cancel")
        }))
        alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { /*[weak self]*/ action in
            //guard let self = self else { return }
            coordinator.start()
        }))
        present(alert, animated: true)
    }
}
