import UIKit
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext!

    @IBOutlet weak var textStudentID: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    
    @IBAction func loginStudent(_ sender: Any) {
        let num = Int(textStudentID.text!)
        if(textStudentID.text! != "" && textPassword.text! != "") {
            if(num != nil) {
                searchFromEntity()
            } else {
                showDialog(title: "Error", message: "Invalid credentials!")
            }
        } else {
            showDialog(title: "Error", message: "Blank field not allowed!")
        }
    }
    
    func searchFromEntity() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Accounts")
        
        request.predicate = NSPredicate(format: "student_id = %@", textStudentID.text!); request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request);
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    let tempSID = result.value(forKey: "student_id") as? String
                    let tempPass = result.value(forKey: "password") as? String
                    
                    if(tempSID == textStudentID.text && tempPass == textPassword.text) {
                        performSegue(withIdentifier: "loginSegue", sender: self)
                    }
                }
                
                showDialog(title: "Error", message: "Invalid Credentials")
                
            } else {
                print("No results")
                showDialog(title: "Invalid Request", message: "No student found with Student ID #"+textStudentID.text!)
            }
        } catch {
            print("Couldn't fetch results")
        }
    }
    
    func checkLoggedName() -> String {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Accounts")
        var name: String! = ""
        
        request.predicate = NSPredicate(format: "student_id = %@", textStudentID.text!);
        request.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(request);
            for result in results as! [NSManagedObject] {
                let tempFN = result.value(forKey: "first_name") as! String
                let tempLN = result.value(forKey: "last_name") as! String
                name = tempFN+" "+tempLN
            }
        } catch {
            print("error")
        }
        
        return name;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loginSegue" {
            let homeController = segue.destination as! HomeController
            homeController.loggedStudentID = textStudentID.text!
            homeController.loggedStudentName = checkLoggedName()
        }
    }
    
    func showDialog(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        context = appDelegate.persistentContainer.viewContext
        
        self.textPassword.delegate = self;
        self.textStudentID.delegate = self;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textPassword.text = ""
        textStudentID.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}


