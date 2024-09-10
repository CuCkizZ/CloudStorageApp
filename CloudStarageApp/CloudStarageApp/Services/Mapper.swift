//
//  Mapper.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 29.07.2024.
//

import Foundation
import CoreData

final class Mapper {
    
    private let dataManager = CoreManager.shared
    
    func mapProfile(_ model: Account) -> ProfileDataSource {
        let totalSpace = model.totalSpace
        let usedSpace = model.usedSpace
        let leftSpace = totalSpace - usedSpace
        
        self.dataManager.addProfileData(totalSpace: model.totalSpace,
                                        usedSpace: model.usedSpace,
                                        leftSpace: leftSpace)
        
        return .init(totalSpace: totalSpace,
                     usedSpace: usedSpace,
                     leftSpace: leftSpace
        )
    }
    
    func mapCoreData(_ model: Embedded, type: TypeOfEntity) {
        model.items.forEach({ item in
            self.dataManager.addItemsTo(to: type,
                                        name: item.name,
                                        date: item.created,
                                        size: String(describing: item.size),
                                        mimeType: item.mimeType ?? ""
            )
            self.dataManager.saveContext()
        })
    }
    
    func saveImage(data: Data) {
        dataManager.saveImage(data: data)
        dataManager.saveContext()
    }
    
}

