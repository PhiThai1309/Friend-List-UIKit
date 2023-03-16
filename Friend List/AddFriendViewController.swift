//
//  AddFriendViewController.swift
//  Friend List
//
//  Created by phi.thai on 3/14/23.
//

import UIKit

protocol addViewDelegate {
    func addNewHandler()
}

class AddFriendViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var EmailInputField: UITextField!
    @IBOutlet weak var NameInputField: UITextField!
    
    var delegate: addViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
    }
    @IBAction func BackBtnHandler(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func AddOnClickHandle(_ sender: Any) {
        if EmailInputField.text != "" && NameInputField.text != "" {
            addFriend(name: NameInputField.text!, email: EmailInputField.text!, gender: "Male")
            
            self.dismiss(animated: true)
        } else {
            let alert = UIAlertController(title: "Error!",
                                          message: "Please fill in all field",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Return", style: .default))
            present(alert, animated: true, completion: nil)
        }
        
            self.delegate?.addNewHandler()
    }
    
    func addFriend(name: String, email: String, gender: String) {
        let url = URL(string: "https://gorest.co.in/public/v2/users")!
        let token = "6e892f37b27d3e12257dabddab6806ffce8a0705d4dce4369ed94e672611b6ea"
        
        // Add data to the model
        let uploadDataModel = Friend(name: name, email: email, gender: "Male", status: "active")
        
        // Convert model to JSON data
        guard let jsonData = try? JSONEncoder().encode(uploadDataModel) else {
            print("Error: Trying to convert model to JSON data")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                
                if (response.statusCode != 201) {
                    print("un-success")
                    return
                } else {
                    print("success")
                }
            } else {
                print(error!)
            }
        }
        task.resume()
    }
}
