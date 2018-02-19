//
//  ViewController.swift
//  Todoey
//
//  Created by Noah Wilder on 2018-02-18.
//  Copyright © 2018 Noah Wilder. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Buy Eggs", "Buy Milk", "Buy Flour"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
     //   cell.backgroundColor = UIColor.red
        return cell
    }
    
    //Mark - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //    print(itemArray[indexPath.row])
        
        
        
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        }
        
        tableView.deselectRow(at: indexPath, animated: true) // Deselects after being tapped
        
    }
    
    
    //Mark - Add New Items
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField() // We use this textField as a local variable to store the inputted data from alertTextField
        
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        
        
       
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks the Add Item button on our UIAlert
            
            if let text : String = textField.text {
                print(text)
                self.itemArray.append(text)
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
