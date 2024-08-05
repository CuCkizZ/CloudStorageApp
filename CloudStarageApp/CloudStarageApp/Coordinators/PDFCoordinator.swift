//
//  PDFCoordinator.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 05.08.2024.
//

import Foundation

final class PDFCoordinator: Coorditator {
    
    private let factory = SceneFactory.self
    
    override func start() {
        showPdf()
    }
    
    override func finish() {
        print("finish Login coordinator")
        //finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
}

extension PDFCoordinator {
    func showPdf() {
//        guard let navigationController = navigationController else { return }
//        let vc = factory.makePDFScene
//        navigationController.pushViewController(vc, animated: true)
    }
}
