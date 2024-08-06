//
//  ShareActivityViewModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 06.08.2024.
//

import Foundation

protocol ShareActivityViewModelProtocol {
    func getShareLink(_ shareLink: String) -> String
    func getShareFile(_ shareFile: String)
}

final class ShareActivityViewModel {
//    
    
    private var model: [PublicItem] = []
//    private let coordinator: ProfileCoordinator
//    
//    init(coordinator: ProfileCoordinator) {
//        self.coordinator = coordinator
//    }
//    
}

extension ShareActivityViewModel: ShareActivityViewModelProtocol {
    
    func getShareLink(_ shareLink: String) -> String {
        return shareLink
    }
    
    func getShareFile(_ shareFile: String) {
        
    }
    
    
}
