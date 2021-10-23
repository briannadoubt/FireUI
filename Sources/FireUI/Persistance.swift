//
//  Persistance.swift
//  Persistance
//
//  Created by Brianna Zamora on 9/13/21.
//

import Foundation
import CoreData
#if !AppClip
import Firebase
#endif

class PersistenceController: ObservableObject {

    // Storage for Core Data
    var container: NSPersistentCloudKitContainer

    // An initializer to load Core Data, optionally able
    // to use an in-memory store.
    init(_ model: String, inMemory: Bool = false) {
        // If you didn't name your model Main you'll need
        // to change this name below.
        container = NSPersistentCloudKitContainer(name: model)

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            #if !AppClip
            if let error = error {
                Crashlytics.crashlytics().record(error: error)
            }
            #endif
        }
    }
}
