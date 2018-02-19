//
//  AppDelegate.swift
//  Todoey
//
//  Created by Noah Wilder on 2018-02-18.
//  Copyright © 2018 Noah Wilder. All rights reserved.
//

import UIKit
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // This is the absolute first thing that gets called (before viewDidLoad)
        
// print("User Defaults location:\n\t\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)\n") // This is where the User Defaults are stored
        
        print("\ndidFinishLaunchingWithOptions\n")
        
        return true
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground.
    
        print("\napplicationWillTerminate\n")
        
        self.saveContext()
    }
    
    
    // MARK: - Core Data stack
    
    // A lazy variable on generates its value when its needed (only occupies memory when its needed)
    
    lazy var persistentContainer: NSPersistentContainer = {
      
        let container = NSPersistentContainer(name: "DataModel") // Has to match Data Model name
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
           
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    // The 'context' is similar to the staging area, it is a temporary area before data is committed to permanent storage
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

