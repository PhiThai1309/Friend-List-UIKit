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
        if let email = EmailInputField.text, let name = NameInputField.text {
            addFriend(name: name, email: email, gender: "Male")
            self.dismiss(animated: true)
        } else {
            let alert = UIAlertController(title: "Error!",
                                          message: "Please fill in all field",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Return", style: .default))
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    func addFriend(name: String, email: String, gender: String) {
        let url = URL(string: "https://gorest.co.in/public/v2/users")!
        let token = "6e892f37b27d3e12257dabddab6806ffce8a0705d4dce4369ed94e672611b6ea"
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                
                if (response.statusCode != 200) {
                    return
                }
                
                
                DispatchQueue.main.async{
//                    self.tableView.reloadData()
                }
                
            } else {
                print(error!)
            }
        }
        task.resume()
    }
}
