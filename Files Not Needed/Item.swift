//
//  TodoListTaskData.swift
//  Todoey
//
//  Created by Noah Wilder on 2018-02-18.
//  Copyright © 2018 Noah Wilder. All rights reserved.
//

import UIKit

// Convention to name class the same as the file name

// Encodable means that a class can be encoded into a plist or json
// For a class to be able to be Encodable, it must contain only standard data types, no custom class types

class Item: Codable { // 'Encodable, Decodable' are both represented under 'Codable)
    
    var title : String = ""
    var done : Bool = false // Default value
    
}
