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
import SwipeCellKit

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
    
    //    override func viewWillDisappear(_ animated: Bool) {
    //        super.viewWillDisappear(animated)
    //        let hexCode = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1).hexValue()
    //        updateNavBar(withCode: hexCode)
    //    }
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        if let _ = todoItems?.count {
        //            if todoItems?.count == 0 {
        //                return 1
        //            } else {
        //                return todoItems?.count ?? 1
        //            }
        //        } else {
        //            return 1
        //        }
        return todoItems?.count ?? 1
        
        
        //        if let itemCount = todoItems?.count {
        //            if itemCount == 0 {
        //                return 1
        //            } else {
        //                return itemCount
        //            }
        //        } else {
        //            return 1
        //        }
        //
        //        // return todoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        //        if todoItems?.count == nil {
        //            cell.textLabel?.text = "No Items Added"
        //
        //            guard let backgroundColour = tableView.backgroundColor else { fatalError("Could not get tableView background colour")}
        //            cell.backgroundColor = backgroundColour
        //            cell.tintColor = ContrastColorOf(backgroundColour, returnFlat: true)
        //            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: backgroundColour, isFlat: true)
        //            cell.isUserInteractionEnabled = false
        //
        //        } else if todoItems?.count != 0, let item = todoItems?[indexPath.row] {
        //            cell.isUserInteractionEnabled = true
        if todoItems?.count == nil || todoItems?.count == 0 {
            cell.textLabel?.text = "No Items Added"
            //     cell.isUserInteractionEnabled = false
            guard let backgroundColour = tableView.backgroundColor else { fatalError("Could not get tableView background colour")}
            cell.backgroundColor = backgroundColour
            cell.tintColor = ContrastColorOf(backgroundColour, returnFlat: true)
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: backgroundColour, isFlat: true)
        } else if let item = todoItems?[indexPath.row] {
            
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
        }
        
        
        // Maybe alter the if else statements to check if todoItems is empty
        
        //       print("Row #\(indexPath.row)")
        
        
        
        //        if todoItems!.count < 1 {
        //            cell.textLabel?.text = "No Items Added"
        //            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: cell.backgroundColor!, isFlat: true)
        //
        //            cell.tintColor = ContrastColorOf(tableView.backgroundColor!, returnFlat: true)
        //            cell.backgroundColor = tableView.backgroundColor
        //        }
        
        
        // This ternary operator shortens this block of code
        // Ternary operator ==>
        // value = condition ? conditionIfTrue : conditionIfFalse
        
        return cell
    }
    
    
    
    //MARK - Tableview Delegate Methods
    
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
    
    
    
    
    
//MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        addAlert()
        
    }
    
    
    //MARK: - Add Alert Funciton
    
    func addAlert(alertTitle: String = "Add New Item", alertButton: String = "Add Item", changeItem: Bool = false, indexPath: IndexPath? = nil) {
        var textField = UITextField() // We use this textField as a local variable to store the inputted data from alertTextField
        
        let alert = UIAlertController(title: alertTitle, message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (cancelAction) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        let action = UIAlertAction(title: alertButton, style: .default) { (action) in
            // What will happen once the user clicks the Add Item button on our UIAlert
            
            if textField.text != "" {
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            if changeItem == true {
                                guard let itemForRename = self.todoItems?[indexPath!.row] else { fatalError("Error renaming item") }
                                self.realm.delete(itemForRename)
                                    //self..items.replace(index: indexPath!.row, object: newItem)
                                
                                currentCategory.items.append(newItem)
                                
                            } else {
                                currentCategory.items.append(newItem)
                            }
                            
                            
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
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    
    }
    
    
    
    
    
    // Delete item in Realm Database:
    // realm.delete(item)
    
    
    //MARK: - Model Manipulation Methods
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        self.tableView.reloadData()
    }
    
    //MARK: - Delete item
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    
                    self.realm.delete(itemForDeletion)
                    
                    print("Deleted item from Realm database\n")
                    
                }
            } catch {
                print("\nError deleting item:\n\t\(error)\n")
            }
        }
    }
//    do {
//    try self.realm.write {
//    let newItem = Item()
//    newItem.title = textField.text!
//    newItem.dateCreated = Date()
//    if changeItem == true {
//    guard let itemForRename = self.todoItems?[indexPath.row] else { fatalError("Error renaming item") }
//
//    self.realm.delete(itemForRename)
//    //self..items.replace(index: indexPath!.row, object: newItem)
//
//    currentCategory.items.append(newItem)
//
//    } else {
//    currentCategory.items.append(newItem)
//    }
//
//
//    }
//
//    } catch {
//    print("\nError saving new item:\n\t\(error)\n")
//    }
    override func writeRenameToRealm(indexPath: IndexPath, textField: UITextField, changeItem: Bool) {
        do {
            try self.realm.write {
                let title = textField.text!
                    guard let itemForRename = self.todoItems?[indexPath.row] else { fatalError("Error renaming item") }
                
                    itemForRename.title = title
            }
            
        } catch {
            print("\nError saving new item:\n\t\(error)\n")
        }
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        if orientation == .right {
            var options = SwipeTableOptions()
            options.expansionStyle = .destructive
            return options
        } else {
            var options = SwipeTableOptions()
            // options.expansionStyle = .selection
            options.transitionStyle = .border
            return options
        }
        
    }
    
} // END OF CLASS









//MARK: - Search Bar Nethods

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


