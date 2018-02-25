//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Noah Wilder on 2018-02-19.
//  Copyright © 2018 Noah Wilder. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let barColour = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
    let backColour = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1).darken(byPercentage: 0.3)
    let realm = try! Realm() // This is how you declare/create a new Realm
    
    var categories: Results<Category>? // The results we get back with data type of Category
    // Data type 'Results':
    //      Whenever you try to query your Realm database, the results you get back are in the form of a result object
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let hexCode = barColour.hexValue()
        updateNavBar(withCode: hexCode)
        tableView.backgroundColor = backColour
        
    }
    
    
    //MARK: - Nav Bar Setup Methods
    func updateNavBar(withCode colourHexCode: String) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.") }
        guard let navBarColour = UIColor(hexString: colourHexCode) else { fatalError() }
        
        let contrastColour : UIColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        navBar.barTintColor = navBarColour
        
        navBar.tintColor = contrastColour
        navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : contrastColour]
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : contrastColour]
        
    }
    
    
    
    
    
    
    
    //MARK: - Add Button Action
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            if textField.text != "" {
                let newCategory = Category() // Object of Category class
                newCategory.colour = UIColor.randomFlat.hexValue()
                newCategory.name = textField.text!
                self.save(category: newCategory)
//                self.tableView.backgroundColor = UIColor(hexString: self.categories?[(self.categories?.count)! - 1].colour ?? "FFFFFF")?.darken(byPercentage: 0.45)
                self.tableView.backgroundColor = self.backColour
                
                
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
        
        /*      Nil Coalescing Operator:
                    - If categories is nil, return categories.count
                    - But if it is nil, return 1
        */
        
        return categories?.count ?? 1 // This is an example of a Nil Coalescing Operateor
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        // This taps into the cell at the given row in the SwipeTableViewController class and takes on all of its properties as defined there. This allows us to choose our own text in this ViewController file
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        
        cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].colour ?? "FFFFFF")
        cell.textLabel?.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: cell.backgroundColor!, isFlat: true)
        
//        tableView.backgroundColor = UIColor(hexString: categories?[(categories?.count)! - 1].colour ?? "FFFFFF")?.darken(byPercentage: 0.45)
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
        
    }
    
    //MARK: - Delete Data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("\nError deleting category:\n\t\(error)\n")
            }
        
            // We dont need to reloadData because the destructive swipe action in the function below already gets rid of the row
//            self.tableView.backgroundColor = UIColor(hexString: categories?[(categories?.count)! - 1].colour ?? "FFFFFF")?.darken(byPercentage: 0.5)
            
        }
    }
    
    
    
} // END OF CLASS
