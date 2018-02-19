//
//  ViewController.swift
//  Todoey
//
//  Created by Noah Wilder on 2018-02-18.
//  Copyright © 2018 Noah Wilder. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item() // newItem is now an object of type Item() (inheritted from the class 'Item')
        newItem.title = "Buy Eggs"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy Milk"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Buy Flour"
        itemArray.append(newItem3)
        
        
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {

            itemArray = items

            print("Saved Tasks:")
            for num in 1...items.count {
                print("\t\(num). \(items[num - 1])")
            }
            print("\n")
        }
        
        
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
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
//
        
        return cell
    }
    
    //Mark - Tableview Delegate Methods
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //    print(itemArray[indexPath.row])
        
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done // It equals its opposite value
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true) // Deselects after being tapped
        
        
        
    }
    
    
    //Mark - Add New Items
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField() // We use this textField as a local variable to store the inputted data from alertTextField
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        
       
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks the Add Item button on our UIAlert
            
            
            if let text : String = textField.text {
                let newItem = Item()
                newItem.title = text
                
                self.itemArray.append(newItem)
                self.defaults.set(self.itemArray, forKey: "TodoListArray") // The key is used to access, retrieve, identify this data within defaults
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
    
    
    
    
    
    
    
}

extension UIColor {
    
    static let mint = #colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1)
    
}
