//
//  Item.swift
//  Todoey
//
//  Created by erick on 2/2 /19.
//  Copyright © 2019 erick. All rights reserved.
//

import Foundation

class Item: Codable {
    //Codable means encodable and decodable
    
    var title : String = ""
    var done : Bool = false
}
