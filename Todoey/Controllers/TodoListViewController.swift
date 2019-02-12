//
//  ViewController.swift
//  Todoey
//
//  Created by erick on 2/2 /19.
//  Copyright © 2019 erick. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var todoItems : Results<Item>?
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //dinisable na itong mga codes ng newItem dahil gumawa ng bagong function sa dulo na loadItems
        //        let newItem = Item()
        //        newItem.title = "Find Nemo"
        //        todoItems.append(newItem)
        //
        //        let newItem2 = Item()
        //        newItem2.title = "Eat Banana"
        //        todoItems.append(newItem2)
        //
        //        let newItem3 = Item()
        //        newItem3.title = "Destroy Earth"
        //        todoItems.append(newItem3)
        
        
        
        //kapareho sana ito ng function ng codes sa ibaba, pero gumawa ng bagong method dahil sa loading ng data mula sa datafilepath
        
        //        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
        //            todoItems = items
        //        }
        //ito ang naglo-load ng saved data mula sa user defaults, useful lalo na kapag na-terminate yung app
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
            //ito ay Ternary operator, kapareho lang ang function nito sa if else statement na nasa taas nito
        } else {
            
            cell.textLabel?.text = "No items added"
        }
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(todoItems?[indexPath.row])
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        //        context.delete(todoItems[indexPath.row])
        //          todoItems.remove(at: indexPath.row)
        
        //        todoItems?[indexPath.row].done = !todoItems[indexPath.row].done
        //
        //        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        //ginawa tong var textField para maging available yung new item text sa action, ginawa syang local variable tapos inequal sya sa alertTextField sa ibaba
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen when the user clicks the Add Item button on the UIAlert
            
            if let currentCategory = self.selectedCategory {
                do {
                    
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new item")
                }
            }
            
            self.tableView.reloadData()
            
            //            let newItem = Item(context: self.context)
            //
            //            newItem.title = textField.text!
            //            newItem.done = false
            //            newItem.parentCategory = self.selectedCategory
            //            self.todoItems.append(newItem)
            //para ma-add yung item sa row
            
            
            //            self.defaults.set(self.todoItems, forKey: "TodoListArray")
            //para i-save yung current array, ginawa ito para kapag naterminate yung app at ni-reload ay hindi mawala yung mga data
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            print(alertTextField.text!)
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Model Manipulation Methods
    
    //    func save(item: Item) {
    //
    //        do {
    //            try realm.write {
    //                realm.add(item)
    //            }
    //        } catch {
    //            print("Error saving context, \(error)")
    //        }
    //
    //        tableView.reloadData()
    //
    //    }
    //
    //
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
        
    }
    
}

//MARK - Search bar methods

extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
        print(searchBar.text!)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async{
                searchBar.resignFirstResponder()
            }


        }
    }
}

