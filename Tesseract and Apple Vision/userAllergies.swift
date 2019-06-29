//
//  userAllergies.swift
//  Tesseract and Apple Vision
//
//  Created by Sonia Purohit on 11/17/18.
//  Copyright © 2018 Sonia Purohit. All rights reserved.
//

import UIKit
import CoreData

var allergyList = [NSManagedObject]()

class userAllergies: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(self.addItem))
    }
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Entity")
        
        do{
            let result = try managedContext.fetch(fetchRequest)
            allergyList = result as! [NSManagedObject]
        } catch{
            
        }
    }
    
    @objc func addItem(sender: UIBarButtonItem){
        let alertController = UIAlertController(title: "Input Allergy", message: "", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Add", style: .default) { (UIAlertAction) in
            /*if let field = alertController.textFields![0] as? UITextField {
            }*/
            if let alertTextField = alertController.textFields?.first, alertTextField.text != nil{
                self.saveItem(itemToSave: alertTextField.text!)
                print("not nil")
                self.tableView.reloadData()
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(confirm)
        alertController.addAction(cancel)
        alertController.addTextField { (textField) in
            textField.placeholder = "Type Keyword"
        }
        self.present(alertController, animated: true, completion: nil)
    }

    func saveItem(itemToSave: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Entity", in: managedContext)
        let item = NSManagedObject(entity: entity!, insertInto: managedContext)
        item.setValue(itemToSave, forKey: "item")
        
        do{
            try managedContext.save()
            allergyList.append(item)
        } catch{
            
        }
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let item = allergyList[indexPath.row]
        cell.textLabel?.text = item.value(forKey: "item") as! String

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allergyList.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete{
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(allergyList[indexPath.row])
            allergyList.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
