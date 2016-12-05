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
    
    // TODO1: Move out of AVC
    var detailView: ActivityDetailsView!
    
    var isAnimating: Bool = false
    var dropDownViewIsDisplayed: Bool = false
    
    // MARK: Filter DropDown
    let whenDropDown = DropDown()
    @IBOutlet weak var filterWhenOutlet: UIBarButtonItem!

    // MARK: Data
    let ref = FIRDatabase.database().reference()
    var activities = [Activity]()
    var selectedActivity: Activity?
    let teamID = UserDefaults.standard.string(forKey: "teamID") ?? " "
    let slackID = UserDefaults.standard.string(forKey: "slackID") ?? " "
    
    // TODO: Figure out "Feed Refresh" -> Pull Down
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

        let frame = CGRect(x: 0.02*self.view.frame.maxX, y: 0.02*self.view.frame.maxY, width: self.view.frame.width*0.95, height: self.view.frame.height*0.96)

        // TODO1: Move out of AVC
        self.detailView = ActivityDetailsView(frame: frame)
        setUpWhenBarDropDown()
        setUpActivityCollectionCells()

        createLayout()

        // MARK: Update activities array from Firebase

        let activitiesRef = ref.child(teamID).child("activities")
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

        var activity = self.activities[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "activityCollectionCell", for: indexPath) as! ActivitiesCollectionViewCell

        if cell.delegate == nil { cell.delegate = self }

        // TODO: Move cell update to cell
        OperationQueue.main.addOperation {
            cell.updateCell(with: self.activities[indexPath.row])
            self.activities[indexPath.row].imageview = cell.activityImageView.image

        OperationQueue.main.addOperation {
            cell.updateCell(with: activity)
        }
        self.activities[indexPath.row].imageview = activity.imageview

    }
        return cell
    }
    
    // TODO: Move image download to cell
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

    // TODO: WillDisplayCell
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        var activity = self.activities[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "activityCollectionCell", for: indexPath) as! ActivitiesCollectionViewCell

        if cell.activityImageView.image?.description == "smallerAppLogo" {
            self.downloadImage(at: activity.image) { (success, image) in
                DispatchQueue.main.async {
                    cell.activityImageView.image = image
                    activity.imageview = image
                    cell.setNeedsLayout()
                }
            }
        }

    }

    // MARK: DidSelectItemAt -> Show take user to ActivityDetails -> Move logic there
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        self.selectedActivity = self.activities[indexPath.row]

        let activitiesRef = ref.child(teamID).child("activities").child((selectedActivity?.id)!)
        activitiesRef.observe(.value, with: { (snapshot) in

        self.selectedActivity = Activity(snapshot: snapshot)

        self.downloadImage(at: (self.selectedActivity?.image)!, completion: { (success, image) in

            self.selectedActivity?.imageview = image
            self.detailView.selectedActivity = self.selectedActivity
            OperationQueue.main.addOperation {
            if self.detailView.selectedActivity.owner == self.slackID {
            self.detailView.editButton.isHidden = false
            self.detailView.editButton.addTarget(self, action: #selector(self.editSelectedActivity), for: .allTouchEvents)
            self.detailView.joinButton.isHidden = true
            } else {

            self.detailView.editButton.isHidden = true
                if self.detailView.selectedActivity.attendees.keys.contains(self.slackID) {
                    self.detailView.joinButton.setTitle("Leave", for: .normal)


                } else {

                    self.detailView.joinButton.setTitle("Join Us!!!", for: .normal)

                }
                self.detailView.joinButton.addTarget(self, action: #selector(self.joinOrLeaveToActivity), for: .allTouchEvents)

                        }

                    }

                })

            self.detailView.closeButton.addTarget(self, action: #selector(self.dismissView), for: .allTouchEvents)

                self.view.addSubview(self.blurEffectView)

                self.view.addSubview(self.detailView)



        })

        self.detailView.alpha = 0
        UIView.animate(withDuration: 0.4 , animations: {
            self.detailView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.detailView.alpha = 1
        });

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

    // MARK: Dismiss View
    func dismissView() {

        UIView.transition(with: self.activitiesCollectionView, duration: 0.8, options: .transitionCrossDissolve, animations:{
            self.blurEffectView.removeFromSuperview()
            self.detailView.removeFromSuperview()
            self.activitiesCollectionView.alpha = 1
        }) { _ in }
    }

    // MARK: Edit Button takes user to Edit Activity VC
    func editSelectedActivity() {
        performSegue(withIdentifier: "editActivity", sender: self)

    }

    // MARK: Segue to Add Activity VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editActivity" {
            let dest = segue.destination as! AddActivityController
            dest.selectedActivity = self.selectedActivity

        }
    }

    // MARK: Join/Leave Button
    func joinOrLeaveToActivity() {

        let key = self.selectedActivity?.id ?? ""
        let date = self.selectedActivity?.date ?? String(describing: Date())
        let newAttendingUser = [slackID:true]
        let newAttendingActivity: [String:String] = [key:date]

        if self.detailView.joinButton.titleLabel?.text == "Join Us!!!" {
        self.ref.child(teamID).child("users").child(slackID).child("activities").child("activitiesAttending").updateChildValues(newAttendingActivity)

            self.ref.child(teamID).child("activities").child(key).child("attending").updateChildValues(newAttendingUser)
        } else {

        self.ref.child(teamID).child("users").child(slackID).child("activities").child("activitiesAttending").child(key).removeValue()

            self.ref.child(teamID).child("activities").child(key).child("attending").child(slackID).removeValue()
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
