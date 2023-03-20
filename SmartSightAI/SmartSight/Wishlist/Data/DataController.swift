//
//  DataController.swift
//  WishApp
//
//  Created by Marcus Moore on 1/2/23.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    //Tells Coredata we want to use the bookwork data model
    let container = NSPersistentContainer(name: "WishlistItem")
    
    init(){
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}

