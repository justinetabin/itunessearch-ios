//
//  CoreDataStorage.swift
//  iTunesSearch
//
//  Created by Justine Tabin on 6/28/20.
//  Copyright © 2020 Justine Tabin. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStorage {
    private var persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "iTunesStore")
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error as NSError? {
                fatalError("CoreData: \(error) - \(error.userInfo)")
            }
        }
    }
    
    func getBackgroundContext(block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
}
