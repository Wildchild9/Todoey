//
//  ViewController.swift
//  Todoey
//
//  Created by Noah Wilder on 2018-02-18.
//  Copyright © 2018 Noah Wilder. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    // ↓ ↓ ↓ Results of items, this holds an array of items (of datatype Item)
    // ↓ ↓ ↓ This in essaence allows us to read data from our Realm database
   
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    
    var selectedCategory : Category? {
        didSet { // didSet is called upon selected category being set with a value
           // let request : NSFetchRequest<Item> = Item.fetchRequest()
            
            loadItems()
            tableView.separatorStyle = .none
        }
    }

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        guard let colourHex = selectedCategory?.colour else { fatalError() }
        // Use guard in place of an if let statement for something that should succeed like 99% of the time and where you don't need the else statement to carry out various other tasks as you would with if let
       
        
        title = selectedCategory?.name
        
        updateNavBar(withCode: colourHex)
    
        tableView.backgroundColor = UIColor(hexString: colourHex)
    
    
        
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let hexCode = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1).hexValue()
        updateNavBar(withCode: hexCode)
    }
    
    //MARK: - Nav Bar Setup Methods
    func updateNavBar(withCode colourHexCode: String) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.") }
        guard let navBarColour = UIColor(hexString: colourHexCode) else { fatalError() }
        
        let contrastColour : UIColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        searchBar.barTintColor = navBarColour
        navBar.barTintColor = navBarColour
        
        navBar.tintColor = contrastColour
        navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : contrastColour]
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : contrastColour]
        
    }
    
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
       
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            // Ternary operator ==>
            // value = condition ? valueIfTrue : valueIfFalse
            
          
            
            cell.accessoryType = item.done ? .checkmark : .none
            
            if let count = todoItems?.count {
                let percent : CGFloat = CGFloat((0.8 / Double(count) * Double(indexPath.row + 1)))
                cell.backgroundColor = UIColor(hexString: (selectedCategory?.colour)!)?.darken(byPercentage: percent)
                
                print("Cell #\(indexPath.row + 1) - Darkened by \(percent * 100)%")
                cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: cell.backgroundColor!, isFlat: true)
                
                cell.tintColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true) // Cell accessory colour
                
            }
            
        } else {
            cell.textLabel?.text = "No Items Added"
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: cell.backgroundColor!, isFlat: true)
            
            cell.tintColor = ContrastColorOf(tableView.backgroundColor!, returnFlat: true)
            
        }
        
        
        // This ternary operator shortens this block of code
                // Ternary operator ==>
                // value = condition ? conditionIfTrue : conditionIfFalse

        return cell
    }
    

    
    //Mark - Tableview Delegate Methods
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("\nError saving done status:\n\t\(error)\n")
            }
            
        }
        
        self.tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true) // Deselects after being tapped

    }
    
    
    
    
    
    //Mark - Add New Items
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField() // We use this textField as a local variable to store the inputted data from alertTextField
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        
       
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks the Add Item button on our UIAlert
            
            if textField.text != "" {
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                           
                            currentCategory.items.append(newItem) // This appends this item to the list of the given category and simultaneously serves the function of saving it

                        }
                        
                    } catch {
                        print("\nError saving new item:\n\t\(error)\n")
                    }
                }
                self.tableView.reloadData()
            
            }
            
            
        }
        
        
        alert.addTextField { (alertTextField) in // You chose the name of the text field, in this case I chose alertTextField
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            // This allows alertTextField to be used at a wider scope and lets texField actually hold the inputted values
            
            
        }
        
        
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    // Delete item in Realm Database:
        // realm.delete(item)
    
    
    //MARK: - Model Manipulation Methods
    
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

         self.tableView.reloadData()
    }

    //Mark: - Delete item
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("\nError deleting item:\n\t\(error)\n")
            }
        }
    }
    
    
    

    
} // END OF CLASS









//Mark: - Search Bar Nethods

// This is an alternative to just conforming the above class to UISearchBarDelegate within the class above
// This is done in an effort to modularize the code

extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        // ↑ ↑ ↑ This sorts the todoItems array itself
        
        self.tableView.reloadData()
        
    }
        
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        

        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }


        } else {
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            self.tableView.reloadData()
        }
    }
}

