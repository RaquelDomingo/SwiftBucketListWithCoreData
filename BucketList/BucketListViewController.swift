//
//  ViewController.swift
//  BucketList
//
//  Created by Raquel Domingo on 9/12/17.
//  Copyright © 2017 Raquel Domingo. All rights reserved.
//

import UIKit
import CoreData

class BucketListViewController: UITableViewController, AddItemTableViewControllerDelegate{

    var items = [BucketListItem]()
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //tells how many rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItemCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].text
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("selected")
        
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {

        performSegue(withIdentifier: "EditItemSegue", sender: indexPath)
        
    }
    
    //CoreData Remove
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let item = items[indexPath.row]
        managedObjectContext.delete(item)
        
        // save data to the Database
        do{
            try managedObjectContext.save()
        }catch {
            print("\(error)")
        }
        
        items.remove(at: indexPath.row)
        tableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let navigationController = segue.destination as! UINavigationController
        let addItemTableController = navigationController.topViewController as! AddItemTableViewController
            addItemTableController.delegate = self

        if segue.identifier == "EditItemSegue" {
            let indexPath = sender as! NSIndexPath
            let item = items[indexPath.row]
            addItemTableController.item = item.text!
            addItemTableController.indexPath = indexPath
        }
    }
    
    
    //CoreData
    func fetchAllItems(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BucketListItem")
        do{
            let result = try managedObjectContext.fetch(request)
            items = result as! [BucketListItem]
        } catch {
            print("\(error)")
        }
    }
    
    func cancelButtonPressed(by controller: AddItemTableViewController) {
        print("I'm the hidden controller, BUT I am responding to the cancel button press on the top view controller")
        dismiss(animated: true, completion: nil)
    }
    func itemSaved(by controller: AddItemTableViewController, with text: String, at indexPath: NSIndexPath?) {
        
        //update
        if let ip = indexPath{
            
            let item = items[ip.row]
            item.text = text
           
        //save or add new item
        }else {
            
            let item = NSEntityDescription.insertNewObject(forEntityName: "BucketListItem", into: managedObjectContext) as! BucketListItem
            item.text = text
            items.append(item)
            
        }
            //save data to the Database
            do{
                try managedObjectContext.save()
            }catch {
                print("\(error)")
            }
        
        
        tableView.reloadData()
        print("Received text from top view: \(text)")
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllItems()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

