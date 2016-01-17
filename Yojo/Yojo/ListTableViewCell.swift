//
//  ListTableViewCell.swift
//  Yojo
//
//  Created by Animish Gadve on 1/17/16.
//  Copyright © 2016 OMFG Studios. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemSwitch: UISwitch!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var itemName: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addButton.hidden = true;
        self.itemName.enabled = false;
    }
    
    @IBAction func onAddButtonPress(sender: UIButton) {
        self.itemName.enabled = true;
    }
    
    @IBAction func onItemSwitchPressed(sender: UISwitch, forEvent event: UIEvent) {
    }

    
}
