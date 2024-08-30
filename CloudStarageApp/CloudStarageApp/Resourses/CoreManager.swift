//
//  CoreManager.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 30.08.2024.
//

import Foundation
import CoreData

final class CoreManager {
    static let shared = CoreManager()
    private var items = [OfflineItems]()
    
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
        print(items.count)
    }
    
    func setupFetchResultController() -> NSFetchedResultsController<OfflineItems> {
        let fetchRequest = OfflineItems.fetchRequest()
        let context = persistentContainer.viewContext
        let sortDescription = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescription]
        let resultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return resultController
    }
    
    func fetchOfflineData() {
        let request = OfflineItems.fetchRequest()
        if let items = try? persistentContainer.viewContext.fetch(request) {
            self.items = items
        }
    }
    
    func clearData() {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "OfflineItems")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print("Error clearing Core Data: \(error.localizedDescription)")
        }
    }

    
    func addLastItem(name: String, date: String, size: String) {
        let fetchRequest = OfflineItems.fetchRequest()
        let context = persistentContainer.viewContext
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
    }
    
    func addStorageItem(name: String, date: String, size: String) {
        let fetchRequest = OfflineItems.fetchRequest()
        let context = persistentContainer.viewContext
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
    }
    
    func addPublishedItem(name: String, date: String, size: String) {
        let fetchRequest = OfflineItems.fetchRequest()
        let context = persistentContainer.viewContext
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
    }
    
}
