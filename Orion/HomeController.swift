//
//  HomeController.swift
//  Orion
//
//  Created by TIP QC on 07/09/2017.
//  Copyright © 2017 Enriquez. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    var loggedStudentID = ""
    var loggedStudentName = ""

    @IBAction func logoutStudent(_ sender: Any) {
        loggedStudentName = ""
        loggedStudentName = ""
        labelLoggedName.text = ""
        labelLoggedID.text = ""
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var labelLoggedID: UILabel!
    @IBOutlet weak var labelLoggedName: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        labelLoggedID.text = loggedStudentID
        labelLoggedName.text = loggedStudentName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
