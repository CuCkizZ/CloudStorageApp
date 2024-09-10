//
//  CoreManager.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 30.08.2024.
//

import UIKit
import CoreData

enum TypeOfEntity {
    case last
    case storage
    case published
}

fileprivate let modelName = "DataModel"

final class CoreManager {
    
    static let shared = CoreManager()
    private var lastItems = [OfflineItems]()
    private var storageItems = [OfflineStorage]()
    private var publishedItems = [OfflinePublished]()
    private var profile = [OfflineProfile]()
    
    private init() {}
    
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func fetchOfflineData(with type: TypeOfEntity) {
        switch type {
        case .last:
            let request = OfflineItems.fetchRequest()
            if let items = try? persistentContainer.viewContext.fetch(request) {
                self.lastItems = items
            }
        case .storage:
            let request = OfflineStorage.fetchRequest()
            if let items = try? persistentContainer.viewContext.fetch(request) {
                self.storageItems = items
            }
        case .published:
            let request = OfflinePublished.fetchRequest()
            if let items = try? persistentContainer.viewContext.fetch(request) {
                self.publishedItems = items
            }
        }
    }
    
    func clearData(entityName: String) {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Error clearing Core Data: \(error.localizedDescription)")
        }
    }
    
    func saveImage(data: Data) {
//        TODO: save image in coreData
//        let context = persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OfflineItems")
//
//        do {
//            if let existingItems = try context.fetch(fetchRequest) as? [OfflineItems], !existingItems.isEmpty {
//                let item = existingItems.first!
//                item.image = data
//                print("Image updated for existing item")
//            } else {
//                let newItem = OfflineItems(context: context)
//                newItem.image = data
//                print("New item created and image saved")
//            }
//
//            try context.save()
//        } catch {
//            print("Failed to save image: \(error)")
//        }
    }
    
    func addItemsTo(to type: TypeOfEntity, name: String, date: String, size: String, mimeType: String) {
        let context = persistentContainer.viewContext
        var entityName: String
        switch type {
        case .last:
            entityName = StrGlobalConstants.OfflineData.offlineItems
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            fetchRequest.predicate = NSPredicate(format: "name == %@ AND date == %@", name, date)
            do {
                let existingItems = try context.fetch(fetchRequest)
                if existingItems.isEmpty {
                    let items = OfflineItems(context: context)
                    items.name = name
                    items.date = date
                    items.size = size
                    items.mimeType = mimeType
                }
            } catch {
                return
            }
            
            saveContext()
        case .storage:
            entityName = StrGlobalConstants.OfflineData.offlineStorage
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            fetchRequest.predicate = NSPredicate(format: "name == %@ AND date == %@", name, date)
            do {
                let existingItems = try context.fetch(fetchRequest)
                if existingItems.isEmpty {
                    let items = OfflineStorage(context: context)
                    items.name = name
                    items.date = date
                    items.size = size
                    items.mimeType = mimeType
                }
            } catch {
                return
            }
            
            saveContext()
        case .published:
            entityName = StrGlobalConstants.OfflineData.offlinePublished
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            fetchRequest.predicate = NSPredicate(format: "name == %@ AND date == %@", name, date)
            do {
                let existingItems = try context.fetch(fetchRequest)
                if existingItems.isEmpty {
                    let items = OfflinePublished(context: context)
                    items.name = name
                    items.date = date
                    items.size = size
                    items.mimeType = mimeType
                }
            } catch {
                return
            }
            
            saveContext()
        }
    }
    
    func addProfileData(totalSpace: Int, usedSpace: Int, leftSpace: Int) {
        let context = persistentContainer.viewContext
        var entityName: String
        entityName = StrGlobalConstants.OfflineData.offlineProfile
        clearData(entityName: entityName)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        do {
            let existingItems = try context.fetch(fetchRequest)
            if existingItems.isEmpty {
                let profile = OfflineProfile(context: context)
                profile.totalSpace = Float(totalSpace)
                profile.usedSpace = Float(usedSpace)
                profile.leftSpace = Float(leftSpace)
            }
        } catch {
            return
        }
        saveContext()
    }
}
