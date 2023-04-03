//
//  ViewController.swift
//  Friend List
//
//  Created by phi.thai on 3/6/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate, alertDelegate, addViewDelegate, UINavigationControllerDelegate, ViewModelDelegate {
    
    lazy var viewModel: HomeViewModel = {
        return HomeViewModel()
    }()
    
    var initCount = 0;
    
    @IBOutlet weak var friendsCount: UILabel!//friendCountLabel
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: ViewModel delegate
    func didFetch() {
        let alert = UIAlertController(title: "Failed to fetch!",
                                      message: "The API server is down, please wait a moment and pull to refresh to try again",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            return
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func reloadTableView() {
        self.initCount = self.viewModel.friends.count
        self.setFriendsNo(num: self.viewModel.friends.count)
        self.tableView.reloadData()
    }
    
    //MARK: ViewController delegate
    func addNewHandler() {
        print("return")
        viewModel.removeFriends()
        viewModel.fetch()
    }
    
    func onClickHandler(_ cell: TableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let alert = CustomAlert(tableView: tableView, friends: viewModel.getFriends(), indexPath: indexPath)
            alert.delegate = self
            self.present(alert, animated: true)
            
        }
    }
    
    func onCallBack(check: Bool, indexPath: IndexPath) {
        if check {
            viewModel.deleteFriend(index: viewModel.getFriends()[indexPath.row].id!)
            viewModel.removeFriend(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            setFriendsNo(num: viewModel.getFriends().count)
        }
    }
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        setFriendsNo(num: viewModel.friends.count)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(doSomething), for: .valueChanged)
        
        // this is the replacement of implementing: "collectionView.addSubview(refreshControl)"
        tableView.refreshControl = refreshControl
        
        //Enable swipe to go back
        self.navigationController?.interactivePopGestureRecognizer!.delegate = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetch()
        viewModel.delegate = self
    }
    
    
    func setFriendsNo(num: Int) {
        self.friendsCount.text = "You have " + String(num) + (num <= 1 ? " friend" : " friends")
    }
    
    @objc func doSomething(refreshControl: UIRefreshControl) {
        viewModel.removeFriends()
        tableView.reloadData()
        viewModel.fetch()
        setFriendsNo(num: viewModel.friends.count)
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
        return viewModel.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let friend = viewModel.getFriends()[indexPath.row]
        
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
        vc.friend = viewModel.getFriends()[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

