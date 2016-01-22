//
//  ListTableViewCell.swift
//  Yojo
//
//  Created by Animish Gadve on 1/17/16.
//  Copyright © 2016 OMFG Studios. All rights reserved.
//

import UIKit

enum ListItemCellState {
    case inactiveState
    case activeState
}

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemSwitch: UISwitch!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var itemName: UITextField!
    var delegate: AddItemProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        itemName.borderStyle = .None
        setCellState(ListItemCellState.inactiveState)
    }
    
    func setCellState(state:ListItemCellState) {
        if (state == ListItemCellState.inactiveState) {
            itemSwitch.hidden = true
            addButton.hidden = false
        } else {
            itemSwitch.hidden = false
            addButton.hidden = true
        }
    }
    
    @IBAction func onAddButtonPress(sender: UIButton) {
        if(itemName.text != "") {
            if let delegate = self.delegate {
                delegate.addItemController(self, didAddItem: itemName.text!)
            }
        }
    }
    
    @IBAction func onItemSwitchPressed(sender: UISwitch, forEvent event: UIEvent) {
        
    }

}
