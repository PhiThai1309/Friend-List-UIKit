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
    @IBAction func AddOnClickHandle(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
