//
//  ViewController.swift
//  Todoey
//
//  Created by Mr. & Mrs. Balesaga on 7/7/18.
//  Copyright © 2018 KamBale. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Buy Eggo", "Destroy Demogorgon"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    //MARK: tableView Datasouce
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    //Mark: TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Mark: Add new items pressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Items", style: .default) { (action) in
            //what will happen once user clicks on add button
            self.itemArray.append(textField.text!)
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alerttextfield) in
            alerttextfield.placeholder = "Create New Item"
            textField = alerttextfield
            
        }
        
        
        alert.addAction(action)
            
            
            present(alert,animated: true,completion: nil)
        }
        
    
    
    
}

