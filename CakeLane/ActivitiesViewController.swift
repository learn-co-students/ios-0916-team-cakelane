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

    var activitiesCollectionView: UICollectionView!
    var activities = [Activity]()
    var blurEffectView: UIVisualEffectView!
    var detailView: ActivityDetailsView!
    let ref = FIRDatabase.database().reference()
    var selectedActivity: Activity?
    var isAnimating: Bool = false
    var dropDownViewIsDisplayed: Bool = false

    let whenDropDown = DropDown()


    @IBOutlet weak var filterWhenOutlet: UIBarButtonItem!

    override func viewWillAppear(_ animated: Bool) {
        viewDidLoad()
    }

    override func viewDidLoad() {

        print(SlackAPIClient.getUserInfo(with: ))


        super.viewDidLoad()
        guard let teamID = UserDefaults.standard.string(forKey: "teamID") else {return}

        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        navigationItem.title = "Teem!"
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orange]
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.tabBarController?.tabBar.barTintColor = UIColor.black
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.orange
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.orange
        self.navigationController?.navigationBar.isTranslucent = false
        self.tabBarController?.tabBar.isTranslucent = false

        let frame = CGRect(x: 0.05*self.view.frame.maxX, y: 0.11*self.view.frame.maxY, width: self.view.frame.width*0.9, height: self.view.frame.height*0.81)

        self.detailView = ActivityDetailsView(frame: frame)




        setUpWhenBarDropDown()
        setUpActivityCollectionCells()

        createLayout()

        // update the activities array from Firebase

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


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return activities.count

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        var activity = self.activities[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "activityCollectionCell", for: indexPath) as! ActivitiesCollectionViewCell

        if cell.delegate == nil { cell.delegate = self }

        OperationQueue.main.addOperation {
            cell.updateCell(with: self.activities[indexPath.row])
            self.activities[indexPath.row].imageview = cell.activityImageView.image

        OperationQueue.main.addOperation {
            cell.updateCell(with: activity)

            self.downloadImage(at: activity.image) { (success, image) in
                DispatchQueue.main.async {
                    cell.activityImageView.image = image
                    activity.imageview = image
                    cell.setNeedsLayout()
                }
            }


        }
        self.activities[indexPath.row].imageview = activity.imageview
        
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        self.selectedActivity = self.activities[indexPath.row]
        guard let teamID = UserDefaults.standard.string(forKey: "teamID") else {return}

        let activitiesRef = ref.child(teamID).child("activities").child((selectedActivity?.id)!)
        activitiesRef.observe(.value, with: { (snapshot) in

            self.selectedActivity = Activity(snapshot: snapshot)

                self.downloadImage(at: (self.selectedActivity?.image)!, completion: { (success, image) in
                    self.selectedActivity?.imageview = image
                    self.detailView.selectedActivity = self.selectedActivity
                     guard let slackID = UserDefaults.standard.string(forKey: "slackID") else {return}
                    if self.detailView.selectedActivity.owner == slackID {

                        self.detailView.editButton.isHidden = false
                        self.detailView.editButton.addTarget(self, action: #selector(self.editSelectedActivity), for: .allTouchEvents)


                    }else{
                        self.detailView.editButton.isHidden = true
                    }

                })

            self.detailView.closeButton.addTarget(self, action: #selector(self.dismissView), for: .allTouchEvents)

            self.detailView.joinButton.addTarget(self, action: #selector(self.joinToActivity), for: .touchUpInside)

            self.view.addSubview(self.blurEffectView)

            self.view.addSubview(self.detailView)




        })

        self.detailView.alpha = 0
        UIView.animate(withDuration: 0.4 , animations: {
            self.detailView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.detailView.alpha = 1
        });

    }


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    @IBAction func filterWhenAction(_ sender: Any) {
        whenDropDown.show()
    }

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

    // WhenDropDown Filters
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
    
    func dismissView() {

        UIView.transition(with: self.activitiesCollectionView, duration: 0.8, options: .transitionCrossDissolve, animations:{
            self.blurEffectView.removeFromSuperview()
            self.detailView.removeFromSuperview()
            self.activitiesCollectionView.alpha = 1
        }) { _ in }
    }

    func editSelectedActivity() {
        performSegue(withIdentifier: "editActivity", sender: self)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editActivity" {
            let dest = segue.destination as! AddActivityController
            dest.selectedActivity = self.selectedActivity

        }
    }


    func joinToActivity() {

        guard let teamID = UserDefaults.standard.string(forKey: "teamID") else {return}
        guard let slackID = UserDefaults.standard.string(forKey: "slackID") else {return}
        let key = self.selectedActivity?.id ?? ""
        let date = self.selectedActivity?.date ?? String(describing: Date())
        let newAttendingUser = [String(describing: self.selectedActivity?.attendees.count):slackID]
        let newAttendingActivity: [String:String] = [key:date]
 self.ref.child(teamID).child("users").child(slackID).child("activities").child("activitiesAttending").updateChildValues(newAttendingActivity)
        self.ref.child(teamID).child("activities").child(key).child("attending").updateChildValues(newAttendingUser)
    }
}


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
