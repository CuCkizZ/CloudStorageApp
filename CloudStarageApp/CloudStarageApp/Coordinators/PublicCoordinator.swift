//
//  PublicCoordinator.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 02.08.2024.
//

import Foundation

final class PublicCoordinator: Coordinator {
    
    private let factory = SceneFactory.self
    
    override func start() {
        print("public coordinator started")
    }
    
    override func finish() {
        print("finish Login coordinator")
        finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}
