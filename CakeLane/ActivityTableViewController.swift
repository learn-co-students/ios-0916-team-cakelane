//
//  ActivityTableViewController.swift
//  FireBaseTesting
//
//  Created by Rama Milaneh on 11/14/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Firebase

class ActivityTableViewController: UITableViewController {

    var activities = [Activity]()
    let activitiesRef = FIRDatabase.database().reference(withPath: "activities")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Mark: - example of how to create child on firebase

        let databaseRef = FIRDatabase.database().reference()
        let users = databaseRef.child("users")
        let newUser = users.child("slackUserID123434")
        let dictionary = ["activitiesCreated":[], "attendedActivities":[]]
        let userDictionary = ["name": "Henry","activities": dictionary] as [String:Any]
        newUser.setValue(userDictionary)

        // Mark: - How to retrieve information from firebase

        self.activitiesRef.observe(.value, with: { (snapshot) in

            var newActivites = [Activity]()

            for activity in snapshot.children {
                let item = Activity(snapshot: activity as! FIRDataSnapshot)
                newActivites.append(item)
            }

            self.activities = self.sortedActivities(newActivites)
            OperationQueue.main.addOperation {


                self.tableView.reloadData()
            }

        })


        SlackAPIClient.getUserInfo { userInfo in
            print("SLACK JSON+++++++++++++++++++++++++++++++++\n\n")
            print(UserDefaults.standard.object(forKey: "SlackToken"))
            print(UserDefaults.standard.object(forKey: "SlackUser"))
            print(userInfo)
            print("SLACK JSON+++++++++++++++++++++++++++++++++\n\n")
        }


    }

    override func viewWillAppear(_ animated: Bool) {

        OperationQueue.main.addOperation {
            print(self.activities)
            self.tableView.reloadData()

        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return activities.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "activityCell", for: indexPath)
        let activityItem = activities[indexPath.row]
        cell.textLabel?.text = activityItem.name
        cell.detailTextLabel?.text = activityItem.date
        return cell
    }

    // MARK: _ Sort the activities based on time
    func sortedActivities(_ array: [Activity]) -> [Activity] {
        let sortedArray = array.sorted { (a, b) -> Bool in
            var result = false
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.long
            if let aDate = dateFormatter.date(from: a.date){
                if let bDate = dateFormatter.date(from: b.date){
                    if aDate < bDate {
                        result = true
                    }
                }
            }
            return result
        }
        return sortedArray
    }

}
