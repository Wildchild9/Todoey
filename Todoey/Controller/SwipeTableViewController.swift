//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Noah Wilder on 2018-02-24.
//  Copyright © 2018 Noah Wilder. All rights reserved.
//

import UIKit
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
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
            // handle action by updating model with deletion
//
            print("\nDelete Cell \"\(tableView.cellForRow(at: indexPath)?.textLabel?.text ?? " (Could not find title)")\"\n")
            
            self.updateModel(at: indexPath)

            
        }
        
//        print("item deleted")
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        // Update data model
    }
}
