//
//  RegisterController.swift
//  Orion
//
//  Created by TIP QC on 07/09/2017.
//  Copyright © 2017 Enriquez. All rights reserved.
//

import UIKit
import CoreData

class RegisterController: UIViewController, UITextFieldDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext!
    
    @IBOutlet weak var textFirstName: UITextField!
    @IBOutlet weak var textLastName: UITextField!
    @IBOutlet weak var textStudentID: UITextField!
    @IBOutlet weak var textPassword: UITextField!

    @IBAction func registerStudent(_ sender: Any) {
        let num = Int(textStudentID.text!)
        if(num != nil) {
            if(textStudentID.text != "" && textFirstName.text != "" && textLastName.text != "" && textPassword.text != "") {
                saveToEntity()
                showDialog(title: "Success", message: "Successfully registered student #"+textStudentID.text!)
                clearFields()
            } else {
                showDialog(title: "Error", message: "Error has occurred when adding student.")
            }
        } else {
            self.showDialog(title: "Error", message: "Invalid student ID!")
        }
    }
    
    func saveToEntity() {
        if(checkAddIfExisting()) {
            let newUser = NSEntityDescription.insertNewObject(forEntityName: "Accounts", into: context)
            newUser.setValue(textStudentID.text, forKey: "student_id")
            newUser.setValue(textPassword.text, forKey: "password")
            newUser.setValue(textFirstName.text, forKey: "first_name")
            newUser.setValue(textLastName.text, forKey: "last_name")
            
            do {
                try context.save()
                print("Saved")
            } catch {
                print("There was an error")
            }
        }
    }
    
    func checkAddIfExisting() -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Accounts")
        var flag: Bool! = false
        
        request.predicate = NSPredicate(format: "student_id = %@", textStudentID.text!);
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request);
            if results.count > 0 {
                showDialog(title: "Error", message: "Student #"+textStudentID.text!+" is already existing.")
                flag = false
            } else {
                flag = true
            }
        } catch {
            print("error")
        }
        
        return flag
    }
    
    func showDialog(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func clearFields() {
        textStudentID.text = ""
        textPassword.text = ""
        textFirstName.text = ""
        textLastName.text = ""
    }
    
    @IBAction func dismissController(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        context = appDelegate.persistentContainer.viewContext
        
        self.textStudentID.delegate = self;
        self.textPassword.delegate = self;
        self.textFirstName.delegate = self;
        self.textLastName.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
