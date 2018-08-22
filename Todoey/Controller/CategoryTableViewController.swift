//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Omar Boffil on 8/14/18.
//  Copyright © 2018 Omar Boffil. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        loadCategory()
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        
        return cell
        
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      performSegue(withIdentifier: "goToItems", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationCV = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationCV.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Method
    
    func save(category: Category){
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch{
            print("error saving category, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
   func loadCategory() {
    
       categories = realm.objects(Category.self)

       tableView.reloadData()
    
}

    

    @IBAction func addbButtonPressed(_ sender: UIBarButtonItem) {
        
        //MARK: - TableView Delegate Methods
        
        var textFiel = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //what happen whem you prest
            
            let newCategory = Category()
            newCategory.name = textFiel.text!
            
            self.save(category: newCategory)
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new categoty"
            textFiel = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil )
    }
    

}
