//
//  Category.swift
//  Todoey
//
//  Created by Omar Boffil on 8/18/18.
//  Copyright © 2018 Omar Boffil. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}

