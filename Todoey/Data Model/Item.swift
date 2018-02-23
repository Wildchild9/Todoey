//
//  Item.swift
//  Todoey
//
//  Created by Noah Wilder on 2018-02-21.
//  Copyright © 2018 Noah Wilder. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false // Default value of done is dalse
    
// Inverse relationship:
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    // fromType : Category.self --> from Data type of Category
    // property : "items" --> name of forward relationship as a string
    
    
    
    
}


/*
 Regular:
     var title : String = ""
     var done : Bool = false
 
 With Realm:
     @objc dynamic var title : String = ""
     @objc dynamic var done : Bool = false
 
 */
