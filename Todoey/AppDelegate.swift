//
//  AppDelegate.swift
//  Todoey
//
//  Created by Noah Wilder on 2018-02-18.
//  Copyright © 2018 Noah Wilder. All rights reserved.
//

import UIKit
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // This is the absolute first thing that gets called (before viewDidLoad)
       
        
        
        // File location of Realm database
        print("\nRealm file location:\n\t\(Realm.Configuration.defaultConfiguration.fileURL!.asString())\n")
        // .asString is an extension I created located at the bottom of AppDelegate.swift
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        do {
            _ = try Realm()
        // An underscore (_) is used since we never actually use the value aside from its initialization
            
        } catch {
            // This checks if there are any aerrors when initializing our realm
            print("Error initializing new realm:\n\t\(error)")
        }
    
        return true
        
    }
}




extension URL {
    func asString() -> String {
        var url = "\(self)"
        url.removeFirst(7)
        return url
    }
}
