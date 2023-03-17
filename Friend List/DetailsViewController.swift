//
//  DetailsViewController.swift
//  Friend List
//
//  Created by phi.thai on 3/17/23.
//

import Foundation
import UIKit

class DetailsViewController: UIViewController, UINavigationBarDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var inactiveCheckBox: CheckBox!
    @IBOutlet weak var activeCheckBox: CheckBox!
    @IBOutlet weak var femaleCheckBox: CheckBox!
    @IBOutlet weak var maleCheckBox: CheckBox!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var navigationTitle: UINavigationItem!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    var friend: Friend?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.delegate = self
        navigationTitle.title = String(friend?.id ?? 0)
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
          
        if let value = friend {
            nameField.text = value.name
            emailField.text = value.email
            imageView.image = UIImage(named: value.gender + "-placeholder")
            if friend?.gender == "male" {
                maleCheckBox.check = true
            } else {
                femaleCheckBox.check = true
            }
            
            if friend?.status == "active" {
                activeCheckBox.check = true
            } else {
                inactiveCheckBox.check = true
            }
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
                                                      message: "Please check your input or the server is down, please wait a moment before submit again",
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
        if let name = nameField.text, let email = emailField.text, let gender = maleCheckBox.check ? "male" : "female", let status = activeCheckBox.check ? "active" : "inactive" {
            var updateFriend = Friend(name: name, email: email, gender: gender, status: status)
            update(friend: updateFriend, id: (friend?.id)!)
        }
    }
    
    @IBAction func MaleClickHandler(_ sender: Any) {
        if(femaleCheckBox.check){
            femaleCheckBox.check = false
            maleCheckBox.check = true
        }
    }
    
    @IBAction func FemaleClickHandler(_ sender: Any) {
        if(maleCheckBox.check){
            femaleCheckBox.check = true
            maleCheckBox.check = false
        }
    }
    
    @IBAction func ActiveClickHandler(_ sender: Any) {
        if(inactiveCheckBox.check){
            inactiveCheckBox.check = false
            activeCheckBox.check = true
        }
    }
    
    @IBAction func InactiveClickHandler(_ sender: Any) {
        if(activeCheckBox.check){
            inactiveCheckBox.check = true
            activeCheckBox.check = false
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
      guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
      else {
        // if keyboard size is not available for some reason, dont do anything
        return
      }

      let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height , right: 0.0)
      scrollView.contentInset = contentInsets
      scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillHide(notification: NSNotification) {
      let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
          
      
      // reset back the content inset to zero after keyboard is gone
      scrollView.contentInset = contentInsets
      scrollView.scrollIndicatorInsets = contentInsets
    }
}
