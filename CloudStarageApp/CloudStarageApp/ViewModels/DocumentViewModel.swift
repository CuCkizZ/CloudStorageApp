//
//  PDFViewModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 05.08.2024.
//

import Foundation

final class DocumentViewModel {
    
    private let coordinator: Coordinator
    var fileType: String
    
    init(coordinator: Coordinator, fileType: String) {
        self.coordinator = coordinator
        self.fileType = fileType
    }
}
