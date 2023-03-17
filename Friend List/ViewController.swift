//
//  ViewController.swift
//  Friend List
//
//  Created by phi.thai on 3/6/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate, alertDelegate, addViewDelegate, UINavigationControllerDelegate {
    
    var friends: [Friend] = []
    
    var initCount = 0;
    
    @IBOutlet weak var friendsCount: UILabel!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: ViewController delegate
    func addNewHandler() {
        print("return")
        friends.removeAll()
        fetch()
    }
    
    func onClickHandler(_ cell: TableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let alert = CustomAlert(tableView: tableView, friends: friends, indexPath: indexPath)
            alert.delegate = self
            alert.show()
        }
    }
    
    func onCallBack(check: Bool, indexPath: IndexPath) {
        if check {
            deleteFriend(index: friends[indexPath.row].id!)
            friends.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            setFriendsNo(num: friends.count)
        }
    }
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        setFriendsNo(num: friends.count)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(doSomething), for: .valueChanged)
        
        // this is the replacement of implementing: "collectionView.addSubview(refreshControl)"
        tableView.refreshControl = refreshControl
        
        //Enable swipe to go back
        self.navigationController?.interactivePopGestureRecognizer!.delegate = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetch()
    }
    
    
    func setFriendsNo(num: Int) {
        self.friendsCount.text = "You have " + String(num) + (num <= 1 ? " friend" : " friends")
    }
    
    @objc func doSomething(refreshControl: UIRefreshControl) {
        //        if friends.count != initCount {
        friends.removeAll()
        tableView.reloadData()
        fetch()
        setFriendsNo(num: friends.count)
        //        }
        refreshControl.endRefreshing()
    }
    
    @IBAction func addBtnHandler(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddFriendView") as! AddFriendViewController
        vc.delegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    //MARK: Table view logic
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailsView") as! DetailsViewController
        vc.friend = friends[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
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
                        let alert = UIAlertController(title: "Failed to fetch!",
                                                      message: "The API server is down, please wait a moment and pull to refresh to try again",
                                                      preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                            return
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    return
                }
                
                do {
                    self.friends = try JSONDecoder().decode([Friend].self, from: data)
                } catch {
                    
                }
                
                DispatchQueue.main.async{
                    self.initCount = self.friends.count
                    self.setFriendsNo(num: self.friends.count)
                    self.tableView.reloadData()
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

