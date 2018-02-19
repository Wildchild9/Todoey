//
//  ViewController.swift
//  Todoey
//
//  Created by Noah Wilder on 2018-02-18.
//  Copyright © 2018 Noah Wilder. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet { // didSet is called upon selected category being set with a value
           // let request : NSFetchRequest<Item> = Item.fetchRequest()
            
            print("\n\(selectedCategory?.name!)\n")
            loadItems()
        }
    }
    
    // Tap in to AppDelegate as an object
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)\n")
       
        
    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = itemArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = item.title
        
        // Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        // This ternary operator shortens this block of code
        

        
        return cell
    }
    
    //Mark - Tableview Delegate Methods
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //    print(itemArray[indexPath.row])
    
        
      // Delete items
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        // .done = its opposite value (toggles value)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true) // Deselects after being tapped
        
    }
    
    
    //Mark - Add New Items
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField() // We use this textField as a local variable to store the inputted data from alertTextField
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        
       
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks the Add Item button on our UIAlert
            
            
            
            if let text : String = textField.text {
                let newItem = Item(context: self.context) // This is the view context of the persistant container
                newItem.done = false
                newItem.title = text
                newItem.parentCategory = self.selectedCategory
                
                self.itemArray.append(newItem)

                self.saveItems()
                
            }
            
            //                self.defaults.set(self.itemArray, forKey: "TodoListArray") // The key is used to access, retrieve, identify this data within defaults
            
        }
        
        
        alert.addTextField { (alertTextField) in // You chose the name of the text field, in this case I chose alertTextField
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            // This allows alertTextField to be used at a wider scope and lets texField actually hold the inputted values
            
            
        }
        
        
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //Mark - Model Manipulation Methods
    
    func saveItems() {
        
        
        do {
            try context.save()
            
        } catch {
            print("\n* Error saving context: *\n\(error)")
        }
        self.tableView.reloadData()
    }
    
    
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) { // The first world is the external parameter, while the second term is the internal parameter
        // Item.fetchRequest() is the default value
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest() // You need to specify data type and data type of the output (<outputDataType>)
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
       
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        
        do {
            itemArray = try context.fetch(request)
        } catch {
           print("\n* Error fetching data from context: *\n\(error)")
        }
        
         self.tableView.reloadData()
    }
    
}

//Mark: - Search Bar Nethods

// This is an alternative to just conforming the above class to UISearchBarDelegate within the class above
// This is done in an effort to modularize the code

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) // %@ is sort of like a place holder for the 'text' argument
        // [cd] means it is case and diacritic insensitive
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            
        loadItems(with: request, predicate: request.predicate!)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
        if searchBar.text?.count == 0 {
            loadItems()
           
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            
        }
    }
    
}






