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
        
//        let activitiesRef = FIRDatabase.database().reference(withPath: "activities")
        let databaseRef = FIRDatabase.database().reference()
        let users = databaseRef.child("users")
        let newUser = users.child("SlackUserID123434")
        let dictionary = ["My activities":["ActID1","ActID6"], "Attending":["ActID5","ActID8"]]
        let userDictionary = ["name": "Henry","Activities": dictionary] as [String : Any]
        newUser.setValue(userDictionary)
        print("A")
        // MARK: - How to retrieve information from firebase
        self.activitiesRef.observe(.value, with: { (snapshot) in
            
            var newActivites = [Activity]()
            
            for activity in snapshot.children {
                let item = Activity(snapshot: activity as! FIRDataSnapshot)
                newActivites.append(item)
            }
            
            self.activities = newActivites
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                print("B")
            }
            
        })
        
        SlackAPIClient.getUserInfo { userInfo in
            print("SLACK JSON+++++++++++++++++++++++++++++++++\n\n")
            dump(userInfo)
            print("SLACK JSON+++++++++++++++++++++++++++++++++\n\n")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tableView.reloadData()
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
        
        // Configure the cell...

        return cell
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
