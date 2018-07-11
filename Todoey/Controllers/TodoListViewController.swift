//
//  ViewController.swift
//  Todoey
//
//  Created by Mr. & Mrs. Balesaga on 7/7/18.
//  Copyright © 2018 KamBale. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory : Catergory? {
        didSet{
            loaditems()
        }
    }
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
         print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

  
    }
    //MARK: tableView Datasouce
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        
        //Ternary Operator ==>
        //value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done ? .checkmark : .none
        
    
        return cell
        
    }
    
    //Mark: TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
//        updating NSManaged Object data to our database
//        itemArray[indexPath.row].setValue("Completed", forKey: "title")
//
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)

        saveItems()

        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Mark: Add new items pressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add new Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Items", style: .default) { (action) in
            //what will happen once user clicks on add button
            
           
            
            let newItem = Item(context: self.context)
            newItem.done = false
            newItem.parentCatergory = self.selectedCategory
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
          self.saveItems()
        }
        
        alert.addTextField { (alerttextfield) in
            alerttextfield.placeholder = "Create New Item"
            textField = alerttextfield
            
        }
        
        
        alert.addAction(action)
            
            
            present(alert,animated: true,completion: nil)
        }
    //Mark: Model Manipulation Methods
    
    func saveItems() {
        
        do {
           try context.save()
        } catch {
           print("error saving context \(error)")
        }
        
        
        self.tableView.reloadData()
        
    }
    
    func loaditems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCatergory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
    

        do{
        itemArray = try context.fetch(request)
        } catch {
            print("Error fetching Data from Context \(error)")
        }
        tableView.reloadData()
    }
    
   
    
}

//Mark: - Search Bar Method

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
         request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loaditems(with: request, predicate: predicate)

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count  == 0 {
            loaditems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

