//
//  ViewController.swift
//  Friend List
//
//  Created by phi.thai on 3/6/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate, alertDelegate {
    
    var friends: [Friend] = []
    
    @IBOutlet weak var friendsCount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    func onClickHandler(_ cell: TableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            print("Radio Tapped at \(indexPath)")
            let alert = CustomAlert(tableView: tableView, friends: friends, indexPath: indexPath)
            alert.delegate = self
            alert.show()
        }
    }
    
    func onCallBack(check: Bool, indexPath: IndexPath) {
        if check {
            friends.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.friendsCount.text = "You have " + String(self.friends.count) + (self.friends.count <= 1 ? " friend" : " friends")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetch()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let friend = friends[indexPath.row]
        
        // Fetch a cell of the appropriate type.
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        
        // Configure the cell’s contents.
        cell.set(img: friend.gender, name: friend.name, status: friend.status, email: friend.email)
        cell.delegate = self
        return cell
    }
    
    func fetch() {
        // Create a URLRequest for an API endpoint
        let url = URL(string: "https://gorest.co.in/public/v2/users")!
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                
                if (response.statusCode != 200) {
                    return
                }
                
                let friendsList = try? JSONDecoder().decode([Friend].self, from: data)
                for i in 0..<friendsList!.count{
                    let new = Friend(id: friendsList![i].id, name: friendsList![i].name, email: friendsList![i].email, gender: friendsList![i].gender, status: friendsList![i].status)
                    self.friends.append(new)
                }
                
                DispatchQueue.main.async{
                    self.friendsCount.text = "You have " + String(self.friends.count) + (self.friends.count <= 1 ? " friend" : " friends")
                    self.tableView.reloadData()
                }
                
            } else {
                print(error!)
            }
        }
        task.resume()
    }
    
}

