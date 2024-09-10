//
//  OfflineProfile+CoreDataProperties.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 31.08.2024.
//
//

import Foundation
import CoreData


extension OfflineProfile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OfflineProfile> {
        return NSFetchRequest<OfflineProfile>(entityName: "OfflineProfile")
    }

    @NSManaged public var attribute: Int16
    @NSManaged public var attribute1: Int16
    @NSManaged public var leftSpace: Int16

}

extension OfflineProfile : Identifiable {

}
