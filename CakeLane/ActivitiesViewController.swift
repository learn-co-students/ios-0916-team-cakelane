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

class ActivitiesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

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
    
    // TODO: Figure out "Feed Refresh" -> Pull Down
    // TODO: RECURSIVE CALL FOR ACTIVITY BATCH OF SIZE (10)
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

        // MARK: DropDown Setup
        setUpWhenBarDropDown()
        setUpActivityCollectionCells()

        createLayout()

        // MARK: Update activities array from Firebase

        let activitiesRef = firebaseClient.ref.child(teamID).child("activities")
        activitiesRef.observe(.value, with: { (snapshot) in

            var newActivites = [Activity]()

            for activity in snapshot.children {
                let item = Activity(snapshot: activity as! FIRDataSnapshot)

                newActivites.append(item)
            }
            OperationQueue.main.addOperation {
                self.activities = self.sortedActivities(newActivites)
                self.activitiesCollectionView.reloadData()
            }

        })


        // MARK: Filter activities via "Filter" DropDown
        whenDropDown.selectionAction = { [unowned self] (index,item) in

            if index == 0 {

                activitiesRef.observe(.value, with: { (snapshot) in

                    var newActivites = [Activity]()

                    for activity in snapshot.children {
                        let item = Activity(snapshot: activity as! FIRDataSnapshot)
                        newActivites.append(item)
                    }
                    OperationQueue.main.addOperation {
                        self.activities = self.sortedActivities(newActivites)
                        self.activitiesCollectionView.reloadData()
                    }
                })
            }

            if index == 1 {

                activitiesRef.observe(.value, with: { (snapshot) in
                    var newActivites = [Activity]()

                    for activity in snapshot.children {
                        let item = Activity(snapshot: activity as! FIRDataSnapshot)
                        newActivites.append(item)
                    }
                    OperationQueue.main.addOperation {
                        self.activities = self.filterTodayActivities(newActivites)
                        self.activitiesCollectionView.reloadData()
                    }
                })
            }

            if index == 2 {
                activitiesRef.observe(.value, with: { (snapshot) in

                    var newActivites = [Activity]()

                    for activity in snapshot.children {
                        let item = Activity(snapshot: activity as! FIRDataSnapshot)
                        newActivites.append(item)
                    }
                    OperationQueue.main.addOperation {
                        self.activities = self.filterWeekActivities(newActivites)
                        self.activitiesCollectionView.reloadData()
                    }
                })
            }

            if index == 3 {
                activitiesRef.observe(.value, with: { (snapshot) in

                    var newActivites = [Activity]()

                    for activity in snapshot.children {
                        let item = Activity(snapshot: activity as! FIRDataSnapshot)
                        newActivites.append(item)
                    }
                    OperationQueue.main.addOperation {
                        self.activities = self.filterMonthActivities(newActivites)
                        self.activitiesCollectionView.reloadData()
                    }
                })
            }
        }


    }

    // MARK: Self-explanatory func
    func createLayout() {

        view.backgroundColor = UIColor.black
        view.addSubview(activitiesCollectionView)
        activitiesCollectionView.backgroundColor = UIColor.white
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

        if cell.delegate == nil { cell.delegate = self }

        // TODO: Move cell update to cell
        OperationQueue.main.addOperation {
            cell.updateCell(with: self.activities[indexPath.row])
            self.activities[indexPath.row].imageview = UIImage(named: "smallerAppLogo")

        OperationQueue.main.addOperation {
            cell.updateCell(with: activity)
            cell.setNeedsLayout()
        }
        self.activities[indexPath.row].imageview = activity.imageview

    }
        return cell
    }

//    // TODO: WillDisplayCell
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//
//        var activity = self.activities[indexPath.row]
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "activityCollectionCell", for: indexPath) as! ActivitiesCollectionViewCell
//
////        if cell.activityImageView.image?.description == "smallerAppLogo" {
////            cell.downloadImage(at: activity.image) { (success, image) in
////                DispatchQueue.main.async {
////                    cell.activityImageView.image = image
////                    activity.imageview = image
////                    cell.setNeedsLayout()
////                }
////            }
////        }
//
//    }

    // MARK: DidSelectItemAt -> Show take user to ActivityDetails -> Move logic there
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        self.selectedActivity = self.activities[indexPath.row]
        
        // MARK: Notify App Controller ~ show Activity Details
        NotificationCenter.default.post(name: .showActivityDetailsVC, object: self.selectedActivity)

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

    // MARK: _ Sort the activities based on time
    func sortedActivities(_ array: [Activity]) -> [Activity] {
        let sortedArray = array.sorted { (a, b) -> Bool in
            var result = false
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.long
            dateFormatter.timeStyle = .long
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

    // MARK: Today's DropDown Filter
    func filterTodayActivities(_ array: [Activity]) -> [Activity] {
        let filterArray = array.filter { (a) -> Bool in
            var result = false
            let calendar = NSCalendar.current
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.long
            dateFormatter.timeStyle = .long
            if let aDate = dateFormatter.date(from: a.date) {
                if calendar.isDateInToday(aDate){
                    result = true
                }
            }
            return result
        }
        return filterArray
    }

    // MARK: This Week's DropDown Filter
    func filterWeekActivities(_ array: [Activity]) -> [Activity] {
        let filterArray = array.filter { (a) -> Bool in
            var result = false
            let calendar = NSCalendar.current
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.long
            dateFormatter.timeStyle = .long

            let currentDate = Date()
            let currentWeek = calendar.component(.weekOfMonth, from: currentDate)

            if let aDate = dateFormatter.date(from: a.date) {
                let thisWeek = calendar.component(.weekOfMonth, from: aDate)
                if currentWeek == thisWeek {
                    result = true
                }
            }
            return result
        }
        return filterArray
    }

    // MARK: This Month's DropDown Filter
    func filterMonthActivities(_ array: [Activity]) -> [Activity] {
        let filterArray = array.filter { (a) -> Bool in
            var result = false
            let calendar = NSCalendar.current
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.long
            dateFormatter.timeStyle = .long

            let currentDate = Date()
            let currentMonth = calendar.component(.month, from: currentDate)


            if let aDate = dateFormatter.date(from: a.date) {
                let thisMonth = calendar.component(.month, from: aDate)
                if currentMonth == thisMonth {
                    result = true
                }
            }
            return result
        }
        return filterArray
    }

    // MARK: Segue to Add Activity VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editActivity" {
            let dest = segue.destination as! AddActivityController
            dest.selectedActivity = self.selectedActivity

        }
    }

}

// MARK: Activities Delegate ~ Present Attendees VC
extension ActivitiesViewController: ActivitiesDelegate {

    func attendeeTapped(sender: ActivitiesCollectionViewCell) {
        let userTableView = UsersTableViewController()
        let navController = UINavigationController(rootViewController: userTableView)
        userTableView.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(dismissController))
        self.present(navController, animated: false, completion: nil)
    }

    func dismissController() {
        self.dismiss(animated: false, completion: nil)
    }
}
