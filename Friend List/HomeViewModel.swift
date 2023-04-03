//
//  HomeViewModel.swift
//  Friend List
//
//  Created by Doan Phuong on 31/03/2023.
//

import Foundation
import UIKit

protocol ViewModelDelegate: AnyObject {
    func didFetch()
    func reloadTableView()
}

class HomeViewModel {
    var friends: [Friend] = []

    init() {
    }
    
    weak var delegate: ViewModelDelegate?
    
    func getFriends() -> [Friend] {
        return self.friends
    }
    
    func removeFriends() {
        self.friends.removeAll()
    }
    
    func removeFriend(index: Int) {
        self.friends.remove(at: index)
    }
    
    //MARK: HTTPS request
    func fetch() {
        // Create a URLRequest for an API endpoint
        let url = URL(string: "https://gorest.co.in/public/v2/users")!
        let token = "6e892f37b27d3e12257dabddab6806ffce8a0705d4dce4369ed94e672611b6ea"
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                
                if (response.statusCode != 200) {
                    DispatchQueue.main.async{
                        self.delegate?.didFetch()
                    }
                    return
                }
                
                do {
                    self.friends = try JSONDecoder().decode([Friend].self, from: data)
                } catch {
                    
                }
                
                DispatchQueue.main.async{
                    self.delegate?.reloadTableView()
                }
                
            } else {
                print(error!)
            }
        }
        task.resume()
    }
    
    func deleteFriend(index: Int) {
        let url = URL(string: "https://gorest.co.in/public/v2/users/" + String(index))!
        print("https://gorest.co.in/public/v2/users/" + String(index))
        let token = "6e892f37b27d3e12257dabddab6806ffce8a0705d4dce4369ed94e672611b6ea"
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                
                if (response.statusCode != 204) {
                    return
                }
                
            } else {
                print(error!)
            }
        }
        task.resume()
    }
    
}
