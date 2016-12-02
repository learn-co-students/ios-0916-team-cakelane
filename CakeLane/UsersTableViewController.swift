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
    var activities = [Activity]()
    let ref = FIRDatabase.database().reference()

    var slackUsersStore = SlackUsersDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orange]
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.orange
        self.navigationController?.title = "Users"
        
        createLayout()
        setUpTableViewCells()
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
        
        print("1111111111111111111")
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        cell = tableView.dequeueReusableCell(withIdentifier: "usersCell", for: indexPath) as! UserTableViewCell
        print("hellooooooooooooo")
        return cell
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
