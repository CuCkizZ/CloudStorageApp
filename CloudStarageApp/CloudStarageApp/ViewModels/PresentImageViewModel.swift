//
//  PresentImageViewModel.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 01.08.2024.
//

import Foundation

protocol PresentImageViewModelProtocol {
    func sizeFormatter(bytes: Int) -> String
    func popToRoot()
    func deleteFile(name: String)
    func shareLink(link: String)
    func shareFile(file: String)
}

final class PresentImageViewModel {
    
    private let coordinator: Coordinator
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}

extension PresentImageViewModel: PresentImageViewModelProtocol {
    
    func popToRoot() {
        coordinator.popTo()
    }
    
    func sizeFormatter(bytes: Int) -> String {
        let kilobytes = Double(bytes) / 1024
        let megabytes = kilobytes / 1024
        
        if megabytes >= 1 {
            let roundedMegabytes = String(format: "%.2f", megabytes)
            return "Размер \(roundedMegabytes) МБ"
        } else {
            let roundedKilobytes = String(format: "%.2f", kilobytes)
            return "Размер \(roundedKilobytes) КБ"
        }
    }
    
    func deleteFile(name: String) {
        NetworkManager.shared.deleteReqest(name: name)
    }
    
    func shareLink(link: String) {
        coordinator.presentAtivityVc(item: link)
    }
    
    func shareFile(file: String) {
        coordinator.presentAtivityVc(item: file)
    }
}
