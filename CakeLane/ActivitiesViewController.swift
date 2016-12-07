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
    
    // MARK: UI
    var activitiesCollectionView: UICollectionView!
    var blurEffectView: UIVisualEffectView!
    
    var isAnimating: Bool = false
    var dropDownViewIsDisplayed: Bool = false
    
    // MARK: Filter DropDown
    let whenDropDown = DropDown()
    @IBOutlet weak var filterWhenOutlet: UIBarButtonItem!
    
    // MARK: Data
    let firebaseClient = FirebaseClient.sharedInstance
    let teamID = FirebaseClient.sharedInstance.teamID
    let slackID = FirebaseClient.sharedInstance.slackID
    var activities = [Activity]()
    var selectedActivity: Activity?
    
    override func viewWillAppear(_ animated: Bool) {
        viewDidLoad()
    }
    
    // TODO: Figure out "Feed Refresh" -> Pull Down & RECURSIVE CALL FOR ACTIVITY BATCH OF SIZE (10)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO1: Use Blur In Segue
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
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
        
        // MARK: REFACTORED -> do we need this?
        // let frame = CGRect(x: 0.02*self.view.frame.maxX, y: 0.02*self.view.frame.maxY, width: self.view.frame.width*0.95, height: self.view.frame.height*0.96)
        // self.detailView = ActivityDetailsView(frame: frame)
        
        // MARK: DropDown Setup
        setUpWhenBarDropDown()
        setUpActivityCollectionCells()
        
        createLayout()
        
        // MARK: Get user info from Slack -> retrieve activities list from Firebase
        SlackAPIClient.storeUserInfo() { success in
            
            FirebaseClient.retrieveActivities(with: self.sortedActivities) { [unowned self] activities in
                DispatchQueue.main.async {
                    
                    print("We're here")
                    
                    self.activities = activities
                    self.activitiesCollectionView.reloadData()
                }
            }
        }
        
        // MARK: Upload user info to Firebase
        FirebaseClient.writeUserInfo()
        
        // MARK: Filter activities via "Filter" DropDown
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
                        self.activities = activities
                        self.activitiesCollectionView.reloadData()
                    }
                }
            }
            
            if index == 2 {
                FirebaseClient.retrieveActivities(with: self.filterWeekActivities) { [unowned self] activities in
                    DispatchQueue.main.async {
                        self.activities = activities
                        self.activitiesCollectionView.reloadData()
                    }
                }
            }
            
            if index == 3 {
                FirebaseClient.retrieveActivities(with: self.filterMonthActivities) { [unowned self] activities in
                    DispatchQueue.main.async {
                        self.activities = activities
                        self.activitiesCollectionView.reloadData()
                    }
                }
            }
        }
        
    }
    
    // MARK: Self-explanatory func
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
    
    // MAR: Setup cells
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
    
    // MARK: Number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return activities.count
        
    }
    
    // MARK: CellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let activity = self.activities[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "activityCollectionCell", for: indexPath) as! ActivitiesCollectionViewCell
        
        // set delegate to allow attendee table view access
        if cell.delegate == nil { cell.delegate = self }
        
        cell.updateCell(with: activity) { (success) in
            cell.downloadAttendeeImages(activity: activity)
            cell.activityImageView.sd_setImage(with: URL(string: activity.image), placeholderImage: UIImage(named: "appLogo-black"))
        }
        
        return cell
    }
    
    // MARK: DidSelectItemAt -> Show take user to ActivityDetails -> Move logic there
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedActivity = self.activities[indexPath.row]
        
        
        
    }
    
    // MARK: Filter Button ~ show DropDown
    @IBAction func filterWhenAction(_ sender: Any) {
        whenDropDown.show()
    }
    
    // MARK: Setup DropDown
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
    
    // MARK: Segue to Add ActivityVC, ActivityDetailsVC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editActivity" {
            let dest = segue.destination as! AddActivityController
            dest.selectedActivity = self.selectedActivity
        }
    }
    
    
    
    // MARK: REFACTORED -> do we need this *here*? I moved this to ActivityDetailsViewController (which reference ActivityDetailsView, which in turn references the .xib)
    
    // func joinOrLeaveToActivity() {
    //
    //     UIView.animate(withDuration: 0.3, animations: {
    //         self.detailView.joinButton.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    //
    //     }, completion: { (success) in
    //         self.detailView.joinButton.transform = CGAffineTransform(scaleX: 1, y: 1)
    //
    //     })
    //
    //
    //     let key = self.selectedActivity?.id ?? ""
    //     let date = self.selectedActivity?.date ?? String(describing: Date())
    //     let newAttendingUser = [slackID:true]
    //     let newAttendingActivity: [String:String] = [key:date]
    //
    //     if self.detailView.joinButton.titleLabel?.text == "Join Us!!!" {
    //     self.ref.child(teamID).child("users").child(slackID).child("activities").child("activitiesAttending").updateChildValues(newAttendingActivity)
    //
    //         self.ref.child(teamID).child("activities").child(key).child("attending").updateChildValues(newAttendingUser)
    //         self.detailView.joinButton.setTitle("Leave", for: .normal)
    //     } else {
    //
    //     self.ref.child(teamID).child("users").child(slackID).child("activities").child("activitiesAttending").child(key).removeValue()
    //
    //         self.ref.child(teamID).child("activities").child(key).child("attending").child(slackID).removeValue()
    //       //  self.detailView.joinButton.setTitle("Join Us!!!", for: .normal)
    //     }
    // }
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
