//
//  AddFriendViewController.swift
//  Friend List
//
//  Created by phi.thai on 3/14/23.
//

import UIKit

class AddFriendViewController: UIViewController {
    
    @IBOutlet weak var EmailInputField: UITextField!
    @IBOutlet weak var NameInputField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func BackBtnHandler(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func AddOnClickHandle(_ sender: Any) {
        if(EmailInputField.text != "" && NameInputField.text != "") {
            self.dismiss(animated: true)
        } else {
            let alert = UIAlertController(title: "Error!",
                                          message: "Please fill in all field",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Return", style: .default))
            present(alert, animated: true, completion: nil)
        }
        
    }
}
