//
//  File.swift
//  Todoey
//
//  Created by Noah Wilder on 2018-02-21.
//  Copyright © 2018 Noah Wilder. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object { // 'Object' is a class that is used to define Realm model objects
    
    // When using Realm, you have to mark variables with the word 'dynamic' before the word 'var' (dynamic var)
    // And because the use of 'dynamic' comes from Objective-C, you have to add the keyword '@objc' before (@objc dynamic var)
    
    @objc dynamic var name : String = ""
    @objc dynamic var age : Int = 0

}








extension URL {
    func asString() -> String {
        var urlString = "\(self)"
        urlString.removeFirst(7)
        return urlString
    }
}
