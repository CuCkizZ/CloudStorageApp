//
//  PathPageCoordinator.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 02.08.2024.
//

import Foundation

final class PathPageCoordinator: Coorditator {
    
    private let factory = SceneFactory.self
    
    override func start() {
        showPage()
    }
    override func finish() {
        print("Im done")
    }
}

extension PathPageCoordinator {
    
    func showPage() {
       
    }
}
