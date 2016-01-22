//
//  ListItem.swift
//  Yojo
//
//  Created by Animish Gadve on 1/21/16.
//  Copyright © 2016 OMFG Studios. All rights reserved.
//

import UIKit

class ListItem: NSObject {
    var itemName = String()
    
    init(name:String) {
        super.init()
        itemName = name
    }
}
