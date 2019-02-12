//
//  Category.swift
//  Todoey
//
//  Created by erick on 9/2 /19.
//  Copyright © 2019 erick. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name : String = ""
let items = List<Item>()
}
