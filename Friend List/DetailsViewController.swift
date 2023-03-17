//
//  DetailsViewController.swift
//  Friend List
//
//  Created by phi.thai on 3/17/23.
//

import Foundation
import UIKit

class DetailsViewController: UIViewController, UINavigationBarDelegate {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var statusField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var friend: Friend?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.delegate = self
        navigationTitle.title = friend?.name
        
        if let value = friend {
            idField.text = String(value.id!)
            nameField.text = value.name
            emailField.text = value.email
            genderField.text = value.gender
            statusField.text = value.status
            imageView.image = UIImage(named: value.gender + "-placeholder")
        }
    }
    
    @IBAction func backClickHandler(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)

    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
     return .topAttached
    }
}
