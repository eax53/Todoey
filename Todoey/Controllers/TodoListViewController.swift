//
//  ViewController.swift
//  Todoey
//
//  Created by erick on 2/2 /19.
//  Copyright © 2019 erick. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
     let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Find Nemo"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Eat Banana"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Destroy Earth"
        itemArray.append(newItem3)
        
        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
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
      
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
     
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//
//        } else {
//            cell.accessoryType = .none
//
//        }
        
        cell.accessoryType = item.done ? .checkmark : .none
        //ito ay Ternary operator, kapareho lang ang function nito sa if else statement na nasa taas nito
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
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
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
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

