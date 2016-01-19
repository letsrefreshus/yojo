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
    
    var listItems = [String]()
    var persistentListItems = [NSManagedObject]()
    var filePath = NSString()
    
    // MARK: - INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromServer()
        initView()
//        loadSampleItems()
        readFromFile()
        insertAddItemCell()
        tableView.registerNib(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "listCell")
    }

    func initView() {
        navigationItem.rightBarButtonItem = editButtonItem();
        filePath = NSTemporaryDirectory() + "list.txt"
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl!)
    }
    
    func refresh(sender:AnyObject)
    {
        getDataFromServer()
    }
    
    
    func loadSampleItems(){
        listItems += ["Eggs", "Milk", "Bread"];
    }
    
    func insertAddItemCell() {
        listItems.insert("", atIndex: listItems.count)
    }
    
    func getDataFromServer() {
        Alamofire.request(.GET, "http://10.0.0.191").responseJSON() {
            response in
            do {
                let anyObj: AnyObject? = try NSJSONSerialization.JSONObjectWithData(response.data!, options:.MutableContainers)
                self.listItems.removeAll()
                for item in anyObj as! Array<AnyObject> {
                    for (_, itemName) in item as! NSMutableDictionary {
                            self.listItems.append(itemName as! String)
                    }
                }
                self.insertAddItemCell()
                self.saveToFile()
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            } catch {
                NSLog("Serialization to String failed on reading")
            }
        }
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
        let itemName = listItems[indexPath.row];
        cell.itemName.text = itemName;
        cell.setCellState(itemName == "" ? ListItemCellState.inactiveState : ListItemCellState.activeState);
        return cell;
    }
    
    func controller(controller: ListTableViewCell, didAddItem: String) {
        listItems.insert(didAddItem, atIndex: (listItems.count - 1));
        saveToFile();
        tableView.reloadData()
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
    
    // MARK: - FILE READ/WRITE
    func saveToFile() {
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(listItems, options:.PrettyPrinted)
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
                        listItems.append(itemName);
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
