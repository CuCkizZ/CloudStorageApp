//
//  Mapper.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 29.07.2024.
//

import Foundation

final class Mapper {
    
    func mappingProfile(_ model: Account) -> ProfileDataSource {
        let totalSpace = model.totalSpace
        let usedSpace = model.usedSpace 
        let leftSpace = totalSpace - usedSpace

        return .init(totalSpace: totalSpace,
                     usedSpace: usedSpace,
                     leftSpace: leftSpace
        )
    }
}
        
//        init(_ storage: Account) {
//            self.total = Float(storage.totalSpace / 1000000000)
//            self.usage = Float(storage.usedSpace / 1000000000)
//            self.left = Float(storage.totalSpace - storage.usedSpace)
//        }

