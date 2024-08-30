//
//  Mapper.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 29.07.2024.
//

import Foundation

final class Mapper {
    
    private let dataManager = CoreManager.shared
    
    func mapProfile(_ model: Account) -> ProfileDataSource {
        let totalSpace = model.totalSpace
        let usedSpace = model.usedSpace 
        let leftSpace = totalSpace - usedSpace

        return .init(totalSpace: totalSpace,
                     usedSpace: usedSpace,
                     leftSpace: leftSpace
        )
    }
    
    func mapLastCoreData(_ model: Embedded) {
        model.items.forEach({ item in
            self.dataManager.addLastItem(name: item.name,
                                         date: item.created,
                                         size: String(describing: item.size))
            self.dataManager.saveContext()
        })
    }
    
    func mapStorageCoreData(_ model: Embedded) {
        model.items.forEach({ item in
            self.dataManager.addStorageItem(name: item.name,
                                         date: item.created,
                                         size: String(describing: item.size))
            self.dataManager.saveContext()
        })
    }
    
    func mapPublishedCoreData(_ model: Embedded) {
        model.items.forEach({ item in
            self.dataManager.addPublishedItem(name: item.name,
                                         date: item.created,
                                         size: String(describing: item.size))
            self.dataManager.saveContext()
        })
    }
    
}
        
//        init(_ storage: Account) {
//            self.total = Float(storage.totalSpace / 1000000000)
//            self.usage = Float(storage.usedSpace / 1000000000)
//            self.left = Float(storage.totalSpace - storage.usedSpace)
//        }

