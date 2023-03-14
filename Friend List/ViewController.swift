//
//  ViewController.swift
//  Friend List
//
//  Created by phi.thai on 3/6/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate, alertDelegate {
    
    var friends: [Friend] = []
    
    var initCount = 0;
    
    @IBOutlet weak var friendsCount: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    func onClickHandler(_ cell: TableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            print("Tapped at \(indexPath)")
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
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(doSomething), for: .valueChanged)
        
        // this is the replacement of implementing: "collectionView.addSubview(refreshControl)"
        tableView.refreshControl = refreshControl
    }
    
    @objc func doSomething(refreshControl: UIRefreshControl) {
        if friends.count != initCount {
            friends.removeAll()
            tableView.reloadData()
            fetch()
        }
        
        // somewhere in your code you might need to call:
        refreshControl.endRefreshing()
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
        let token = "6e892f37b27d3e12257dabddab6806ffce8a0705d4dce4369ed94e672611b6ea"
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if error == nil, let data = data, let response = response as? HTTPURLResponse {
                
                if (response.statusCode != 200) {
                    return
                }
                
                do {
                    self.friends = try JSONDecoder().decode([Friend].self, from: data)
                } catch {
                    
                }
                
                DispatchQueue.main.async{
                    self.initCount = self.friends.count
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

