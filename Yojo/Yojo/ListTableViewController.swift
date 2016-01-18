//
//  ListTableViewController.swift
//  Yojo
//
//  Created by Animish Gadve on 1/17/16.
//  Copyright © 2016 OMFG Studios. All rights reserved.
//

import UIKit
import CoreData

class ListTableViewController: UITableViewController, AddItemProtocol {
    
    var listItems = [String]()
    var persistentListItems = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSampleItems()
        insertAddItemCell()
        initView()
        tableView.registerNib(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "listCell")
    }

    func initView() {
        navigationItem.rightBarButtonItem = editButtonItem();
    }
    
    func loadSampleItems(){
        listItems += ["Eggs", "Milk", "Bread"];
    }
    
    func insertAddItemCell() {
        listItems.insert("", atIndex: listItems.count)
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
//        if(editing) {
//            listItems.removeLast()
//        } else {
//            insertAddItemCell()
//        }
//        tableView.reloadData()
        super.setEditing(editing, animated: animated)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listItems.count;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> ListTableViewCell {
        let cellIdentifier = "listCell";
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ListTableViewCell;
        cell.delegate = self
        let itemName = listItems[indexPath.row];
        cell.itemName.text = itemName;
        cell.setCellState(itemName == "" ? ListItemCellState.inactiveState : ListItemCellState.activeState);
    
        return cell;
    }
    
    func controller(controller: ListTableViewCell, didAddItem: String) {
        listItems.insert(didAddItem, atIndex: (listItems.count - 1));
        tableView.reloadData()
    }


    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        let itemName = listItems[indexPath.row];
        return itemName == "" ? false : true;
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            listItems.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
//    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
//        return UITableViewCellEditingStyle.None
//    }
//    
//    override func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return false;
//    }

    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let itemToMove = listItems[fromIndexPath.row]
        listItems.removeAtIndex(fromIndexPath.row)
        listItems.insert(itemToMove, atIndex: toIndexPath.row)
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        let itemName = listItems[indexPath.row];
        return itemName == "" ? false : true;
    }
    
    // MARK: - CORE DATA

}
