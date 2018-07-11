//
//  CatergoryViewController.swift
//  Todoey
//
//  Created by Mr. & Mrs. Balesaga on 7/10/18.
//  Copyright © 2018 KamBale. All rights reserved.
//

import UIKit
import CoreData

class CatergoryViewController: UITableViewController {
    
    
   var catergories = [Catergory]()
        
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }
    //Mark: - TableView Datasource Method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catergories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatergoryCell", for: indexPath)
        
        cell.textLabel?.text = catergories[indexPath.row].name
        
        return cell
    }

    //Mark: - Data Manipulation Method
    func saveCategories() {

        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
        
        
    }

    func loadCategories() {
        
        let request : NSFetchRequest<Catergory> = Catergory.fetchRequest()
        
        do {
        catergories = try context.fetch(request)
        } catch {
            print("Error Loading Context\(error)")
        }
        
        tableView.reloadData()
    }
    
    
    
    
    
    // Add new Catergories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Catergory", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Catergory(context: self.context)
            
            newCategory.name = textField.text!
            
            self.catergories.append(newCategory)
            
            self.saveCategories()
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new catergory"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //Mark: - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = catergories[indexPath.row]
        }
    }
    
}
