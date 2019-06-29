//
//  printRecognizedText.swift
//  Tesseract and Apple Vision
//
//  Created by Sonia Purohit on 4/15/18.
//  Copyright © 2018 Sonia Purohit. All rights reserved.
//

import UIKit
import CoreData

class printRecognizedText: UIViewController {

    @IBOutlet var textView: UITextView!
    var stringToPrint = ""
    var allergies = [String]()
    var safe = true
    var alertTitle = ""
    var message = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if let range = stringToPrint.lowercased().range(of: "ingredient") {
            let lastPartIncludingDelimiter = stringToPrint.substring(from: range.lowerBound)
            stringToPrint = lastPartIncludingDelimiter
        }
        if let index = stringToPrint.range(of: ".")?.lowerBound { //statement removes all characters after the "." because the period signifies that the ingredient list ended
            stringToPrint = String(stringToPrint[..<(index)])
        }
        textView.text = stringToPrint + "."
        // Do any additional setup after loading the view.
        print("allergy count is " + String(allergyList.count))
        var myString:NSString = stringToPrint as NSString
        var myMutableString = NSMutableAttributedString()
        if allergyList.count > 0{
            let maxIndex = allergyList.count - 1
            for n in 0...maxIndex{
                let item = allergyList[n].value(forKey: "item") as! String
                if stringToPrint.lowercased().range(of: String(item)) != nil {
                    var nsRange = myString.range(of: item)
                    myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: nsRange)
                    print(String(item) + " exists")
                    safe = false
                    alertTitle = "Item is unsafe"
                    message = message + item + " "
                    //textView.attributedText = myMutableString
                }
            }
        }
        if safe == false {
            message = "Contains " + message
        }
        else{
            alertTitle = "Safe to Eat"
            message = "Free of Allergens"
        }
        let alertController = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        let close = UIAlertAction(title: "Dismiss", style: .default)
        alertController.addAction(close)
        self.present(alertController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
