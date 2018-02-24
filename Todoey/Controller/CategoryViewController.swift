//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Noah Wilder on 2018-02-19.
//  Copyright © 2018 Noah Wilder. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm() // This is how you declare/create a new Realm
    
    var categories: Results<Category>? // The results we get back with data type of Category
    // Data type 'Results':
    //      Whenever you try to query your Realm database, the results you get back are in the form of a result object
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
    }
    
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey category", message: "", preferredStyle: .alert)
        
        
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            if textField.text != "" {
                let newCategory = Category() // Object of Category class
                
                newCategory.name = textField.text!
                
                
    //            self.categories.append(newCategory)
                
        // You don't need to append things to categories arrray anymore as it now autoupdates and monitors for changes
                
                self.save(category: newCategory)
                
                
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
        
        
        return categories?.count ?? 1
 
//TODO: - Nil Coalescing Operator
        
/*      Nil Coalescing Operator:
            - If categories is nil, return categories.count
            - But if it is nil, return 1
*/
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
    
        return cell
    }
    
    
    //Mark - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    //MARK: - Data Manipulation Methods
    func save(category: Category) {
        
        
        do {
            try realm.write {
                realm.add(category)
            }
            
        } catch {
            print("\n* Error saving category: *\n\(error)")
        }
        self.tableView.reloadData()
    }
    
    
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//        
//        do {
//            categories = try context.fetch(request)
//        } catch {
//            print("\n* Error fetching data from context: *\n\(error)")
//        }
//
        
       
    }

    
    

    
    
} // END OF CLASS



