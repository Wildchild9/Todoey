//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Noah Wilder on 2018-02-19.
//  Copyright © 2018 Noah Wilder. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey category", message: "", preferredStyle: .alert)
        
        
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            if let text : String = textField.text {
                let newCategory = Category(context: self.context)
                newCategory.name = text
                
                self.categoryArray.append(newCategory)
                
                self.saveCategories()
                
            }
            
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
           
            
            
        }
        
        
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
    
        return cell
    }
    
    
    //Mark - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    func saveCategories() {
        
        
        do {
            try context.save()
            
        } catch {
            print("\n* Error saving context: *\n\(error)")
        }
        self.tableView.reloadData()
    }
    
    
    
    func loadCategories() {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("\n* Error fetching data from context: *\n\(error)")
        }
        
        self.tableView.reloadData()
    }

}



