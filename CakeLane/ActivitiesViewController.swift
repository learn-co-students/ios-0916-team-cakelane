//
//  ActivitiesViewController.swift
//  CakeLane
//
//  Created by Rama Milaneh on 11/22/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import DropDown

class ActivitiesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {

    // UI
    var activitiesCollectionView: UICollectionView!


    var isAnimating: Bool = false
    var dropDownViewIsDisplayed: Bool = false

    // Filter DropDown
    let whenDropDown = DropDown()
    @IBOutlet weak var filterWhenOutlet: UIBarButtonItem!

    // Data
    let slackID = UserDefaults.standard.string(forKey: "slackID") ?? " "
    let teamID = UserDefaults.standard.string(forKey: "teamID") ?? " "
    var activities = [Activity]()
    var selectedActivity: Activity?

    // TODO: Figure out "Feed Refresh" -> Pull Down & RECURSIVE CALL FOR ACTIVITY BATCH OF SIZE (10)
    override func viewDidLoad() {
        super.viewDidLoad()

      print("we are in the view did load 3452637485967089p42q4539w69e0750r68tpy79")

        // MARK: test getTeamInfo
//        SlackAPIClient.getTeamInfo { response in
//            guard let teamInfoResponse = response?["team"] as? [String:Any] else { return }
//            print("\n\n\nTHIS IS THE GETTEAMINFO COMPLETION!!! ++++++++++n\n\n\(teamInfoResponse)\n\n\n")
//            let newTeamInfo = TeamInfo(dictionary: teamInfoResponse)
//            let teamStore = TeamDataStore.sharedInstance
////            teamStore.teamInfo.removeAll()
//            teamStore.teamInfo = newTeamInfo.dictionary
//            teamStore.teamInfo["teemChannel"] = "teem_activities"
//            teamStore.teamInfo["webhook"] = "some webhook"
//            print("\n\n\nTHIS IS THE TEAMSTORE DICTIONARY!!! ++++++++++\n\n\n\(teamStore.teamInfo)\n\n\n")
//        }

//        MARK: Test location for SlackAPIClient.userJoinChannel
//                SlackAPIClient.userJoinChannel { response in
//                    print("\n\n\nTHIS IS THE USER JOIN CHANNEL COMPLETION!!! ++++++++++n\n\n\(response)")
//                }

        // MARK: Navigation Setup
        navigationItem.title = "Teem!"
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orange]
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.tabBarController?.tabBar.barTintColor = UIColor.black
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.orange
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.orange
        self.navigationController?.navigationBar.isTranslucent = false
        self.tabBarController?.tabBar.isTranslucent = false

        // DropDown Setup
        setUpWhenBarDropDown()
        setUpActivityCollectionCells()

        createLayout()

        // MARK: Get user info from Slack -> retrieve activities list from Firebase
        SlackAPIClient.storeUserInfo() { success in
            let teamID = UserDefaults.standard.string(forKey: "teamID") ?? " "
            let activitiesRef = FIRDatabase.database().reference().child(teamID).child("activities")

            activitiesRef.observe(.value, with: { (snapshot) in
                var newActivities = [Activity]()

                for activity in snapshot.children {

                    let item = Activity(snapshot: activity as! FIRDataSnapshot)


                    newActivities.append(item)
                }

                DispatchQueue.main.async {

                    print("We're here")
                    
                    //////////////////////////////////////////////////////////////

                    print("**********))))))))**********\n\n")
                    print(self.activities)
                    print("**********))))))))**********\n\n")

                    self.activities = newActivities

                    // debug from other version: creates duplicates
                     self.activities = self.sortedActivities(newActivities)

                    self.activitiesCollectionView.reloadData()
                    print("The numbers of activties inside the view did load")
                    print(self.activities.count)

                }
            })

        }

        // Filter activities via "Filter" DropDown
        whenDropDown.selectionAction = { [unowned self] (index,item) in

            if index == 0 {
                FirebaseClient.retrieveActivities(with: self.sortedActivities) { [unowned self] activities in
                    DispatchQueue.main.async {
                        self.activities = activities
                        self.activitiesCollectionView.reloadData()
                    }
                }
            }

            if index == 1 {
                FirebaseClient.retrieveActivities(with: self.filterTodayActivities) { [unowned self] activities in
                    DispatchQueue.main.async {
                        self.activities = self.sortedActivities(activities)
                        self.activitiesCollectionView.reloadData()
                    }
                }
            }

            if index == 2 {
                FirebaseClient.retrieveActivities(with: self.filterWeekActivities) { [unowned self] activities in
                    DispatchQueue.main.async {
                        self.activities = self.sortedActivities(activities)
                        self.activitiesCollectionView.reloadData()
                    }
                }
            }

            if index == 3 {
                FirebaseClient.retrieveActivities(with: self.filterMonthActivities) { [unowned self] activities in
                    DispatchQueue.main.async {
                        self.activities = self.sortedActivities(activities)
                        self.activitiesCollectionView.reloadData()
                    }
                }
            }
        }


    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.activitiesCollectionView.reloadData()
    }

    // Self-explanatory func
    func createLayout() {

        view.backgroundColor = UIColor.black
        view.addSubview(activitiesCollectionView)
        activitiesCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.height.equalTo(view.snp.height)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }

    }

    // Setup cells
    func setUpActivityCollectionCells() {

        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height

        //setup Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        layout.itemSize = CGSize(width: screenWidth, height: screenHeight/2)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 0
        activitiesCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        activitiesCollectionView.dataSource = self
        activitiesCollectionView.delegate = self

        activitiesCollectionView.register(ActivitiesCollectionViewCell.self, forCellWithReuseIdentifier: "activityCollectionCell")
        activitiesCollectionView.isUserInteractionEnabled = true

    }

    // Number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return activities.count

    }

    // CellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let activity = self.activities[indexPath.row]

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "activityCollectionCell", for: indexPath) as! ActivitiesCollectionViewCell

        // set delegate to allow attendee table view access
        if cell.delegate == nil { cell.delegate = self }

        cell.updateCell(with: activity) { (success) in

            // placeholder image loads first, once downloaded, actual user image replaces placeholder
            cell.activityImageView.sd_setImage(with: URL(string: activity.image), placeholderImage: UIImage(named: "appLogo-black"))

            cell.downloadAttendeeImages(activity: activity)

        }
        
        return cell
    }

    // DidSelectItemAt -> Show take user to ActivityDetails -> Move logic there
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        self.selectedActivity = self.activities[indexPath.row]
        let destination = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "activity-details-view-controller") as! ActivityDetailsViewController
        destination.selectedActivity = self.selectedActivity

        let cell = self.activitiesCollectionView.cellForItem(at: indexPath) as! ActivitiesCollectionViewCell
        OperationQueue.main.addOperation {
            // overwrite Firebase data store for selected activity ~ use in activity details, users table view
            FirebaseUsersDataStore.sharedInstance.users = cell.users
            FirebaseUsersDataStore.sharedInstance.userImages = cell.arrayOfImages
        }

        self.present(destination, animated: true, completion: nil)

    }

    // Filter Button ~ show DropDown
    @IBAction func filterWhenAction(_ sender: Any) {
        whenDropDown.show()
    }

    // Setup DropDown
    func setUpWhenBarDropDown() {

        whenDropDown.anchorView = filterWhenOutlet
        whenDropDown.dataSource = [

            "All",
            "Today",
            "This Week",
            "This Month",

        ]

        whenDropDown.bottomOffset = CGPoint(x: 0, y:(whenDropDown.anchorView?.plainView.bounds.height)!)
        whenDropDown.backgroundColor = UIColor(red: 25/255, green: 15/255, blue: 8/255, alpha: 0.7)
        whenDropDown.textColor = UIColor.white
        whenDropDown.cornerRadius = 10
        whenDropDown.selectionBackgroundColor = UIColor.orange
        whenDropDown.width = 140


    }


    // Segue to Add ActivityVC, ActivityDetailsVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editActivity" {
            let dest = segue.destination as! AddActivityController
            dest.selectedActivity = self.selectedActivity
        }
    }

}

// MARK: Activities Delegate ~ Present Attendees VC
extension ActivitiesViewController: ActivitiesDelegate {

    func attendeesTapped(sender: ActivitiesCollectionViewCell) {

        guard let indexPathForCell = activitiesCollectionView.indexPath(for: sender) else { return }
        let activity = self.activities[indexPathForCell.row]
        let userTableView = UsersTableViewController()
        userTableView.selectedActivity = activity
        userTableView.userArray = sender.users


        let navController = UINavigationController(rootViewController: userTableView)
        userTableView.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissController))
        self.present(navController, animated: true, completion: nil)

    }

    func dismissController() {
        self.dismiss(animated: false, completion: nil)
    }
}
