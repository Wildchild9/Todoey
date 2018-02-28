//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Noah Wilder on 2018-02-24.
//  Copyright © 2018 Noah Wilder. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80.00 // 75.0
        
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        // You need to make sure (inside of Main.storyboard) that both the TodoItemsViewController cells and the CategoryViewController cells have the identifier "Cells" for them to be able to use these swipe cells
        
        cell.delegate = self
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 19)

        return cell
    }
    
    
    
    //MARK: - Swipe Cell Methods
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .right {
            
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                
                // handle action by updating model with deletion
                //
                print("\nDelete Cell \"\(tableView.cellForRow(at: indexPath)?.textLabel?.text ?? " (Could not find title)")\"\n")
                
                self.updateModel(at: indexPath)
                
                
            }
            deleteAction.image = UIImage(named: "delete-icon")
            return [deleteAction]
        } else {
            return leftSwipeAction(tableView, editActionsForRowAt: indexPath, for: orientation)
        }
        
    }
    
    func leftSwipeAction(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        let renameAction = SwipeAction(style: .default, title: "Rename") { (action, indexPath) in
            //                self.addAlert(alertTitle: "Rename Item", alertButton: "Rename")
            self.renameAlert(alertButton: "Rename", changeItem: true, indexPath: indexPath)
        }
        renameAction.backgroundColor = #colorLiteral(red: 1, green: 0.8319068551, blue: 0, alpha: 1)
        renameAction.image = UIImage(named: "rename-icon1-white-small")
        
        
        return [renameAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
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
    
    func writeRenameToRealm(indexPath: IndexPath, textField: UITextField, changeItem: Bool) {
        // Write rename to database
    }
    
    func updateModel(at indexPath: IndexPath) {
        // Update data model
    }
    
    func alertTitleName() -> String {
        return "Rename Item"
    }
    func renameAlert(alertButton: String = "Rename", changeItem: Bool = false, indexPath: IndexPath? = nil) {
        var textField = UITextField() // We use this textField as a local variable to store the inputted data from alertTextField
        
        let alert = UIAlertController(title: alertTitleName(), message: "", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (cancelAction) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        let action = UIAlertAction(title: alertButton, style: .default) { (action) in
            // What will happen once the user clicks the Add Item button on our UIAlert
            
            if textField.text != "" {
                
                self.writeRenameToRealm(indexPath: indexPath!, textField: textField, changeItem: true)
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
    
    
    
    
    
} // END OF CLASS
