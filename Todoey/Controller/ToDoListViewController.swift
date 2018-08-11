//
//  ViewController.swift
//  Todoey
//
//  Created by Omar Boffil on 8/6/18.
//  Copyright © 2018 Omar Boffil. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(dataFilePath!)
        
        loadItems()
    }

    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        return cell
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print("cell number \(itemArray[indexPath.row])")
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItem()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textFiel = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what happen whem you prest
            let newItem = Item()
            newItem.title = textFiel.text!
            
            self.itemArray.append(newItem)
           
            self.saveItem()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textFiel = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil )
    }
    
    //MARK - Model Manupulation Methods
    
    func saveItem (){
        
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch{
            print("error encodig item, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decorde = PropertyListDecoder()
            do {
                itemArray = try decorde.decode([Item].self, from: data)
            }catch {
                print("Error \(error)")
            }
        }
    }

}
