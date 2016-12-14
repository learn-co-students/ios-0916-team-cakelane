//
//  UsersTableViewController.swift
//  CakeLane
//
//  Created by Henry Chan on 11/29/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import UIKit
import Firebase
import SnapKit


class UsersTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var usersTableView: UITableView!
    let ref = FIRDatabase.database().reference()
    var selectedActivity: Activity?
    
    var firebaseUsersStore = FirebaseUsersDataStore.sharedInstance
    var userArray = FirebaseUsersDataStore.sharedInstance.users
    var userImages = FirebaseUsersDataStore.sharedInstance.userImages
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orange]
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.orange
        self.navigationController?.title = "Users"
        
        guard let activity = selectedActivity else { print("What happened?"); return }
        
        self.createLayout()
        
//        FirebaseClient.downloadAttendeeImagesAndInfo(for: activity) { (images, users) in
//            
//            self.userArray = users
//            self.userImages = images
//
//            self.usersTableView.reloadData()
//        }
        
        self.setUpTableViewCells()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("selected activity")
        print(selectedActivity)
        print(userImages)
        print(userArray)
    }
    
    func dismissController() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func createLayout() {
        
        self.usersTableView = UITableView(frame: CGRect.zero)
        self.view.addSubview(usersTableView)
        self.usersTableView.delegate = self
        self.usersTableView.dataSource = self
        
        usersTableView.snp.makeConstraints { (make) in
            
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.height.equalTo(self.view)
            make.width.equalTo(self.view)
        }
        
    }
    
    func setUpTableViewCells() {
        
        usersTableView.register(UserTableViewCell.self, forCellReuseIdentifier: "usersCell")
        usersTableView.rowHeight = 65
        
    }

    // table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (selectedActivity?.attendees.count)!
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "usersCell", for: indexPath) as! UserTableViewCell
        
        
        let user = userArray[indexPath.row]
        
        downloadImage(at: user.image72) { (success, image) in
            if success {
                OperationQueue.main.addOperation {
                    cell.profileImage.image = image
                }
            }
        }
        if indexPath.row == 0 {
            cell.nameLabel.text = ("\(user.firstName) \(user.lastName)")
            cell.profileImage.layer.borderColor = UIColor.orange.cgColor
            cell.profileImage.layer.borderWidth = 4
            cell.creatorLabel.isHidden = false
        }
        else {
        cell.nameLabel.text = ("\(user.firstName) \(user.lastName)")
        }
    
        
        return cell
    }
    
    
    func downloadImage(at url:String, completion: @escaping (Bool, UIImage)->()){
        let session = URLSession.shared
        let newUrl = URL(string: url)
        if let unwrappedUrl = newUrl {
            let request = URLRequest(url: unwrappedUrl)
            let task = session.dataTask(with: request) { (data, response, error) in
                guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
                
                guard let image = UIImage(data: data) else { return }
                completion(true, image)
            }
            task.resume()
        }
        
    }
    
    // segue to DetailUserViewController
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "user-profile-view-controller") as! UserInfoViewController
        detailVC.user = self.userArray[indexPath.row]
        self.present(detailVC, animated: true, completion: nil)
    }
    
    // MARK: Update user table view cell
    func updateUserTableViewCell() {
        
    }
    
}
