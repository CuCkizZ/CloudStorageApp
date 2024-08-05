//
//  PDFViewModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 05.08.2024.
//

import Foundation

final class PDFViewModel {
    
    private let coordinator: HomeCoordinator
    var fyleType: String
    
    init(coordinator: HomeCoordinator, fyleType: String) {
        self.coordinator = coordinator
        self.fyleType = fyleType
    }
}
