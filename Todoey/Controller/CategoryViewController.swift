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
import SwipeCellKit




class NumberOfRows {
    var count : Int = 1
    static let rows = NumberOfRows()
}


class CategoryViewController: SwipeTableViewController {
    
//    var numberOfRows = 1
    let deleteRed = #colorLiteral(red: 0.9914426208, green: 0.2377755642, blue: 0.1868577898, alpha: 1)
    let barColour = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
    let backColour = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1).darken(byPercentage: 0.3)
    let realm = try! Realm()
    
    var categories: Results<Category>? {
        didSet {
            initialSetNumberOfRows()
        }
    }
        
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .lightContent
        loadCategories()
        tableView.separatorStyle = .none
       
        initialSetNumberOfRows()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let hexCode = barColour.hexValue()
        updateNavBar(withCode: hexCode)
        tableView.backgroundColor = backColour
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]

        initialSetNumberOfRows()
    }
    
    
    //MARK: - Nav Bar Setup Methods
    func updateNavBar(withCode colourHexCode: String) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.") }
        guard let navBarColour = UIColor(hexString: colourHexCode) else { fatalError() }
        
        let contrastColour : UIColor = ContrastColorOf(navBarColour, returnFlat: true)
        
        navBar.barTintColor = navBarColour
        
        navBar.tintColor = contrastColour
        navBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    
    
    
    
    
    
//MARK: - Add Button Action
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (cancelAction) in
            alert.dismiss(animated: true, completion: nil)
        }
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            if textField.text != "" {
                let newCategory = Category() // Object of Category class
                
                let colour : String = self.getNewColour()
                newCategory.colour = colour //UIColor.randomFlat.hexValue()
                newCategory.name = textField.text!
                self.save(category: newCategory)
               
                self.addRow()
                self.tableView.reloadData()
                
                //                self.tableView.backgroundColor = UIColor(hexString: self.categories?[(self.categories?.count)! - 1].colour ?? "FFFFFF")?.darken(byPercentage: 0.45)
                //  self.numberOfRows += 1
                self.tableView.backgroundColor = self.backColour
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    

    
    
    
    
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        /*      Nil Coalescing Operator:
                    - If categories is nil, return categories.count
                    - But if it is nil, return 1
        */

//        initialSetNumberOfRows()
        return NumberOfRows.rows.count
//        return categories?.count ?? 1 // This is an example of a Nil Coalescing Operateor
        
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
    
    
    //MARK: - Tableview Delegate Methods
    
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
    

    override func alertTitleName() -> String {
        return "Rename Category"
    }
    
    
    override func writeRenameToRealm(indexPath: IndexPath, textField: UITextField, changeItem: Bool) {

            do {
                try self.realm.write {
                    let name = textField.text!
                    
                        guard let categoryForRename = self.categories?[indexPath.row] else { fatalError("Error renaming item") }
                        categoryForRename.name = name
//                        self.realm.delete(categoryForRename)
//
//                        //self..items.replace(index: indexPath!.row, object: newItem)
//                        realm.add(newCategory)
                    
                }
                
            } catch {
                print("\nError saving new item:\n\t\(error)\n")
            }
    }
    
    
    
    
//MARK: - Deletion Confirmation
    
    
//    override func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
//        if orientation == .right {
//            var options = SwipeTableOptions()
//            options.expansionStyle = .destructive
//            return options
//        } else {
//            var options = SwipeTableOptions()
//            options.expansionStyle = .selection
//            options.transitionStyle = .border
//            return options
//        }
//
//    }
//
//    override func alertTitleName() -> String {
//        return "Rename Item"
//    }
//
//    override func leftSwipeAction(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        let renameAction = SwipeAction(style: .default, title: "Rename") { (action, indexPath) in
//            //                self.addAlert(alertTitle: "Rename Item", alertButton: "Rename")
//            self.renameAlert(alertButton: "Rename", changeItem: true, indexPath: indexPath)
//        }
//        renameAction.backgroundColor = #colorLiteral(red: 1, green: 0.8319068551, blue: 0, alpha: 1)
//        renameAction.image = UIImage(named: "rename-icon1-white-small")
//
//        let checkAction = SwipeAction(style: .default, title: nil) { (action, indexPath) in
//            //                self.addAlert(alertTitle: "Rename Item", alertButton: "Rename")
//            if let item = self.todoItems?[indexPath.row] {
//                do {
//                    try self.realm.write {
//                        item.done = !item.done
//                    }
//                } catch {
//                    print("\nError saving done status:\n\t\(error)\n")
//                }
//
//            }
//
//            self.tableView.reloadData()
//        }
//
//        checkAction.backgroundColor = mainColour
//        checkAction.image = UIImage(named: "check-icon1-white-small")
//
//        return [checkAction, renameAction]
//    }
    
    
    
//MARK: - Delete Confirmation
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard let categoryName : String = categories?[indexPath.row].name else {
            fatalError ("Error getting category name in swipe cell delegate methods")
        }
        
        //   let initialIndexPath : IndexPath = indexPath
        
        if orientation == .right {
         
            let deleteAction = SwipeAction(style: .default, title: "Delete") { action, indexPath in
                self.confirmation(withName: categoryName) { deleteTapped in
                    if deleteTapped {
                        print("\nDelete Cell \"\(tableView.cellForRow(at: indexPath)?.textLabel?.text ?? " (Could not find title)")\"\n")
                        
                         //{ deletionCompleted in
//                            self.tableView.reloadData()
//                        }
                        
                        
                        
                        NumberOfRows.rows.count -= 1
                        action.fulfill(with: .delete)
                        self.updateRealm(indexPath: indexPath)
                       
                        
                        
                        
                        //                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    } else {
                        self.tableView.reloadData()
                        action.fulfill(with: .reset)
                    }
                }
                
                // handle action by updating model with deletion
            }
            // customize the action appearance
            deleteAction.image = UIImage(named: "delete-icon")
            deleteAction.backgroundColor = deleteRed
            
            return [deleteAction]
            
        } else {
            return leftSwipeAction(tableView, editActionsForRowAt: indexPath, for: orientation)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        if orientation == .right {
            var options = SwipeTableOptions()
            options.expansionStyle = .fill
            return options
        } else {
            var options = SwipeTableOptions()
            // options.expansionStyle = .selection
            options.transitionStyle = .border
            return options
        }
        
    }
    

    func confirmation(withName categoryName: String, completion: @escaping (Bool) -> Void) {
        
        let alert = UIAlertController(title: "Confirmation", message: "Are you sure you want to delete your \"\(categoryName)\" category?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (deleteAction) in
            alert.dismiss(animated: true, completion: nil)
            let deleteTapped = true
            completion(deleteTapped)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
            alert.dismiss(animated: true, completion: nil)
            let deleteTapped = false
            completion(deleteTapped)
        }
        
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func updateRealm(indexPath: IndexPath) { //completion: ((Bool) -> Void)? = nil
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
//                    let deletionCompleted : Bool = true
//                    completion?(deletionCompleted)
                }
            } catch {
                print("\nError deleting category:\n\t\(error)\n")
            }
            
            
        }
    }
    
    
//MARK: - Number of Rows Functions
    
    func initialSetNumberOfRows() {
        if let categoryCount = categories?.count {
            if categoryCount == 0 {
                NumberOfRows.rows.count = 1
            } else {
                NumberOfRows.rows.count = categoryCount
            }
        } else {
            NumberOfRows.rows.count = 1
        }
    }
    
    func addRow() {
        NumberOfRows.rows.count += 1
    }
    
    func removeRow() {
        NumberOfRows.rows.count -= 1
    }
    
    
    
    
    
    
    
    
    
    //MARK: - Get New Colour Function
    
    func getNewColour() -> String {
        var colour : String = ""
        if let count = self.categories?.count {
            var colourArray : [String] = [""]
            //            var iterations = 0
            let sets = count / 48
            let finalCount = count - (sets * 48)
            if finalCount > 0 {
                for num in 1...finalCount {
                    //                if count - 1) % 48 == 0 {
                    //                    colourArray = [""]
                    //
                    //                } else {
                    guard let colourString = self.categories?[num - 1].colour else {fatalError("Could not make array of category colours")}
                    colourArray.append(colourString)
                    //                }
                }
            }
            
            print(tableView.numberOfRows(inSection: 0))
            print("\n\(colourArray)")
            print("\nWe've got \(colourArray.count - 1) colours taken already\n")
            var newColourArray : [String] = [""]
            var colourChecks : Int = 0
            
            while colourArray.contains(newColourArray.last!) {
                
                let newColour = UIColor.randomFlat.hexValue()
                let containsNewColour : Bool = newColourArray.contains(newColour)
                if containsNewColour == false {
                    
                    newColourArray.append(newColour)
                    colourChecks += 1
                    
                }
                //                } else {
                //                    print("Duplicate colour, retry")
                //                }
                
                //print("\nCheck #\(colourChecks): \(newColourArray)\n")
                
            }
            print("\n")
            
            //            var checks : Int = 0
            //            var duplicateArray = newColourArray
            //            duplicateArray.reverse()
            //            var startingCount = newColourArray.count
            //            for _ in 1...duplicateArray.count {
            //                let str = duplicateArray[startingCount-1]
            //                duplicateArray.remove(at: startingCount-1)
            //                startingCount -= 1
            //                if duplicateArray.contains(str) == false {
            //                    checks += 1
            //                    print("\(checks) +++")
            //                } else { print("Duplicate") }
            //            }
            colour = newColourArray.last!
            
            print("New Colour - colour #\(colourArray.count) found in \(colourChecks) try --> \(colour)\n")
            
            return colour
        } else {
            colour = UIColor.randomFlat.hexValue()
            return colour
        }
    }
    
} // END OF CLASS


