//
//  ListTableViewController.swift
//  Yojo
//
//  Created by Animish Gadve on 1/17/16.
//  Copyright © 2016 OMFG Studios. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

class ListTableViewController: UITableViewController, AddItemProtocol {
    
    var listItems = [ListItem]()
    var persistentListItems = [NSManagedObject]()
    var filePath = NSString()
    let serverCommunicator = ServerCommunication()
    
    // MARK: - INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
//        loadSampleItems()
        readFromFile()
        insertAddItemCell()
        getDataFromServer()
        tableView.registerNib(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "listCell")
    }

    func initView() {
        navigationItem.rightBarButtonItem = editButtonItem();
        filePath = NSTemporaryDirectory() + "list.txt"
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(self.refreshControl!)
    }
    
    func refresh(sender:AnyObject)
    {
        getDataFromServer()
    }
    
    
    func loadSampleItems(){
        listItems += [ListItem(name: "Eggs"), ListItem(name: "Milk"), ListItem(name: "Bread")];
    }
    
    func insertAddItemCell() {
        listItems.insert(ListItem(name: ""), atIndex: listItems.count)
    }
    
    func getDataFromServer() {
        serverCommunicator.getDataFromServer({
            (responseData:NSData) -> Void in
            do {
                let anyObj: AnyObject? = try NSJSONSerialization.JSONObjectWithData(responseData, options:.MutableContainers)
                self.listItems.removeAll()
                for item in anyObj as! Array<AnyObject> {
                    for (_, itemName) in item as! NSMutableDictionary {
                            self.listItems.append(ListItem(name: itemName as! String))
                    }
                }
                self.insertAddItemCell()
                self.saveToFile()
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            } catch {
                NSLog("Serialization to String failed on reading")
                self.refreshControl?.endRefreshing()
            }
        })
    }

    // MARK: - TABLE VIEW
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count;
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> ListTableViewCell {
        let cellIdentifier = "listCell";
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ListTableViewCell;
        cell.delegate = self
        let item = listItems[indexPath.row];
        cell.itemName.text = item.itemName;
        cell.setCellState(item.itemName == "" ? ListItemCellState.inactiveState : ListItemCellState.activeState);
        return cell;
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let itemName = listItems[indexPath.row];
        return itemName == "" ? false : true;
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            listItems.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            saveToFile()
        }
    }

    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let itemToMove = listItems[fromIndexPath.row]
        listItems.removeAtIndex(fromIndexPath.row)
        listItems.insert(itemToMove, atIndex: toIndexPath.row)
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let itemName = listItems[indexPath.row];
        return itemName == "" ? false : true;
    }
    
    // MARK:-DELEGATE FOR HANDLING ADDED ITEM
    func addItemController(controller: ListTableViewCell, didAddItem: String) {
        listItems.insert(ListItem(name:didAddItem), atIndex: (listItems.count - 1));
        saveToFile();
        tableView.reloadData()
    }
    
    // MARK: - FILE READ/WRITE TEMP
    func saveToFile() {
        do {
            var listItemNames = [String]()
            for item:ListItem in listItems{
                if (item.itemName != "") {
                    listItemNames.append(item.itemName)
                }
            }
            let data = try NSJSONSerialization.dataWithJSONObject(listItemNames, options:.PrettyPrinted)
            let string = NSString(data: data, encoding: NSUTF8StringEncoding)
            do {
                try string!.writeToFile(filePath as String, atomically: true, encoding: NSUTF8StringEncoding)
            } catch {
                NSLog("Writing to the file failed")
            }
        } catch {
            NSLog("Serialization to JSON failed")
        }
    }
    
    func readFromFile() {
        do {
            let readFile:NSString? = try NSString(contentsOfFile: filePath as String, encoding: NSUTF8StringEncoding)
            let data: NSData = readFile!.dataUsingEncoding(NSUTF8StringEncoding)!
            do {
                let anyObj: AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options:.MutableLeaves)
                for item in anyObj as! Array<AnyObject> {
                    let itemName = item as! String
                    if  itemName != "" {
                        listItems.append(ListItem(name: itemName));
                    }
                }
            } catch {
                NSLog("Serialization to String failed on reading")
            }
        }catch {
            NSLog("Reading from the file failed")
        }
    }

}
