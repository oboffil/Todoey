//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Omar Boffil on 8/14/18.
//  Copyright © 2018 Omar Boffil. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var categories = [Category]()
    
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        loadCategory()
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let item = categories[indexPath.row]
        
        cell.textLabel?.text = item.name
        
        return cell
        
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      performSegue(withIdentifier: "goToItems", sender: self)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationCV = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationCV.selectedCategory = categories[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Method
    
    func saveCategory (){
        
        do {
            try contex.save()
        } catch{
            print("error saving category, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            categories = try contex.fetch(request)
        } catch{
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    

    @IBAction func addbButtonPressed(_ sender: UIBarButtonItem) {
        
        //MARK: - TableView Delegate Methods
        
        var textFiel = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            //what happen whem you prest
            
            let newItem = Category(context: self.contex)
            
            newItem.name = textFiel.text!
            
            self.categories.append(newItem)
            
            self.saveCategory()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a new categoty"
            textFiel = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil )
    }
    
    
}
