//
//  CoreManager.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 30.08.2024.
//

import Foundation
import CoreData

enum TypeOfEntity {
    case last
    case storage
    case published
}

final class CoreManager {
    
    static let shared = CoreManager()
    private var lastItems = [OfflineItems]()
    private var storageItems = [OfflineStorage]()
    private var publishedItems = [OfflinePublished]()
    private var profile = [OfflineProfile]()
    
    private init() {}
    
    public lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
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
    
    func getCount() {
        
    }
    
    //    private func setupFetchResultController() -> NSFetchedResultsController<OfflineItems> {
    //        let fetchRequest = OfflineItems.fetchRequest()
    //        let context = persistentContainer.viewContext
    //        let sortDescription = NSSortDescriptor(key: "name", ascending: true)
    //        fetchRequest.sortDescriptors = [sortDescription]
    //        let resultController = NSFetchedResultsController(fetchRequest: fetchRequest,
    //                                                          managedObjectContext: context,
    //                                                          sectionNameKeyPath: nil,
    //                                                          cacheName: nil)
    //        return resultController
    //    }
    
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
            print("deleted data")
        } catch {
            print("Error clearing Core Data: \(error.localizedDescription)")
        }
    }
    
    
    
    func addItemsTo(to type: TypeOfEntity, name: String, date: String, size: String) {
        let context = persistentContainer.viewContext
        var entityName: String
        switch type {
        case .last:
            entityName = "OfflineItems"
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            fetchRequest.predicate = NSPredicate(format: "name == %@ AND date == %@", name, date)
            do {
                let existingItems = try context.fetch(fetchRequest)
                if existingItems.isEmpty {
                    let items = OfflineItems(context: context)
                    items.name = name
                    items.date = date
                    items.size = size
                }
            } catch {
                print("I cant")
            }
            
            saveContext()
        case .storage:
            entityName = "OfflineStorage"
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            fetchRequest.predicate = NSPredicate(format: "name == %@ AND date == %@", name, date)
            do {
                let existingItems = try context.fetch(fetchRequest)
                if existingItems.isEmpty {
                    let items = OfflineStorage(context: context)
                    items.name = name
                    items.date = date
                    items.size = size
                }
            } catch {
                print("I cant")
            }
            
            saveContext()
        case .published:
            entityName = "OfflinePublished"
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            fetchRequest.predicate = NSPredicate(format: "name == %@ AND date == %@", name, date)
            do {
                let existingItems = try context.fetch(fetchRequest)
                if existingItems.isEmpty {
                    let items = OfflinePublished(context: context)
                    items.name = name
                    items.date = date
                    items.size = size
                }
            } catch {
                print("I cant")
            }
            
            saveContext()
        }
    }
    
    func addProfileData(totalSpace: Int, usedSpace: Int, leftSpace: Int) {
        let context = persistentContainer.viewContext
        var entityName: String
        entityName = "OfflineProfile"
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
//        fetchRequest.predicate = NSPredicate(format: "totalSpace == %@ AND usedSpace == %@", totalSpace, usedSpace)
        do {
            let existingItems = try context.fetch(fetchRequest)
            if existingItems.isEmpty {
                clearData(entityName: entityName)
                let profile = OfflineProfile(context: context)
                profile.totalSpace = Float(totalSpace)
                profile.usedSpace = Float(usedSpace)
                profile.leftSpace = Float(leftSpace)
            }
        } catch {
            print("I cant")
        }
        saveContext()
    }
}
