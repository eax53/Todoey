//
//  ViewController.swift
//  Todoey
//
//  Created by erick on 2/2 /19.
//  Copyright © 2019 erick. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Find Nemo", "Get married", "Destroy Earth"]
    
     let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
                    }
        //ito ang naglo-load ng saved data mula sa user defaults, useful lalo na kapag na-terminate yung app
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
        } else {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        //ginawa tong var textField para maging available yung new item text sa action, ginawa syang local variable tapos inequal sya sa alertTextField sa ibaba
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when the user clicks the Add Item button on the UIAlert
            print(textField.text!)
            
            self.itemArray.append(textField.text!)
            //para ma-add yung item sa row
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            //para i-save yung current array, ginawa ito para kapag naterminate yung app at ni-reload ay hindi mawala yung mga data
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            print(alertTextField.text!)
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}

