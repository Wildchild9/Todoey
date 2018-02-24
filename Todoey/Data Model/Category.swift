//
//  Category.swift
//  Todoey
//
//  Created by Noah Wilder on 2018-02-21.
//  Copyright © 2018 Noah Wilder. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    
// Forward relationship:
    
    let items = List<Item>() // This syntax specifies the type of data in the List
    
    // 'List' comes from Realm and is similar to an array
    
}

/* Syntax:

 Same expression:
    Syntax 1 --> let array : [Int] = [1,2,3]
    Syntax 2 --> let array : Array<Int> = [1,2,3]

 Same expression:
     Syntax 1 --> let array = [Int]()
     Syntax 2 --> let array = Array<Int>()
 
 
*/
