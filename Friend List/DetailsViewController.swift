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
    @IBOutlet weak var imageView: UIImageView!
    
    var friend: Friend?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.delegate = self
        navigationTitle.title = String(friend?.id ?? 0)
        
        if let value = friend {
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
    
    func update(friend: Friend, id: Int) {
        // Create a URLRequest for an API endpoint
        let url = URL(string: "https://gorest.co.in/public/v2/users/" + String(id))!
        let token = "6e892f37b27d3e12257dabddab6806ffce8a0705d4dce4369ed94e672611b6ea"
        
        // Convert model to JSON data
        guard let jsonData = try? JSONEncoder().encode(friend) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "PATCH"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                
                if (response.statusCode != 200) {
                    print("un-success")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Error!",
                                                      message: "Please check your input",
                                                      preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Return", style: .default))
                        self.present(alert, animated: true, completion: nil)
                    }
                    return
                } else {
                    print("success")
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Success",
                                                      message: "You have change the information successfully",
                                                      preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                
            } else {
                print(error!)
            }
        }
        task.resume()
    }
    
    @IBAction func submitClickHandler(_ sender: Any) {
        if let name = nameField.text, let email = emailField.text, let gender = genderField.text, let status = statusField.text {
            var updateFriend = Friend(name: name, email: email, gender: gender, status: status)
            update(friend: updateFriend, id: (friend?.id)!)
        }
        
    }
}
