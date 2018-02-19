//
//  AppDelegate.swift
//  Todoey
//
//  Created by Noah Wilder on 2018-02-18.
//  Copyright © 2018 Noah Wilder. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // This is the absolute first thing that gets called (before viewDidLoad)
        
        print("User Defaults location:\n\t\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)\n") // This is where the User Defaults are stored
        
        print("didFinishLaunchingWithOptions\n")
        
        return true
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Called when for example, a user gets a call while filling out a form in the app; this is used to save data in these situations.
        
        
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
       // This is called when you click the home button and the application is resides in the background
        
        print("didEnterBackground\n")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground.
        
        
        
        print("applicationWillTerminate\n")
    }


}

