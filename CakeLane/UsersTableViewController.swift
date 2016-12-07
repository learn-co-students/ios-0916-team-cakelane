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
    var userArray = [User]()

    var firebaseUsersStore = FirebaseUsersDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orange]
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.orange
        self.navigationController?.title = "Users"
        
        createLayout()
        setUpTableViewCells()
        
        
        //get all users
//        getUsers {
//            self.usersTableView.reloadData()
//        }
    }
    
//    func getUsers(completion:()->()){
//        print("running get users")
//    
//        for eachUser in (selectedActivity?.attendees.keys)! {
//            let teamID = UserDefaults.standard.string(forKey: "teamID")
//            let userRef = ref.child(teamID!).child("users").child(eachUser)
//
//            userRef.observeSingleEvent(of:.value, with: { (snapshot) in
//                let dictionary = snapshot as! [String:Any]
//                print(dictionary)
//            
//                let user = User(dictionary: dictionary)
//                print(user)
//                self.userArray.append(user)
//                
//            })
//        }
//        completion()
//        
//
//        
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("+++++++++++++++++++++\(selectedActivity)")
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

    // MARK: - Table view data source
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
        cell.nameLabel.text = ("\(user.firstName) \(user.lastName)")
        
        
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

    // TODO: Prepare for segue to DetailUserViewController
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        <#code#>
//    }

}
