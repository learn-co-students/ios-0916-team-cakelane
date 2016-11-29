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
    let whenDropDown = DropDown()
    let whatDropDown = DropDown()
    
    
    @IBOutlet weak var filterWhenOutlet: UIBarButtonItem!
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        guard let teamID = UserDefaults.standard.string(forKey: "teamID") else {return}
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        navigationItem.title = "Best App"
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.orange]
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.tabBarController?.tabBar.barTintColor = UIColor.black
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.orange
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.orange


        let frame = CGRect(x: 0.05*self.view.frame.maxX, y: 0.05*self.view.frame.maxY, width: self.view.frame.width*0.9, height: self.view.frame.height*0.81)

        self.detailView = ActivityDetailsView(frame: frame)
        
        setUpWhenBarDropDown()
        setUpActivityCollectionCells()
        createLayout()
        
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
        
//        filterActions()
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

        activitiesCollectionView.register(ActivitiesCollectionViewCell.self, forCellWithReuseIdentifier: "activityCell")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return activities.count
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "activityCell", for: indexPath) as! ActivitiesCollectionViewCell
        
//        let copyActivitiesCollectionCell = ActivitiesCollectionViewCell()
//        let copyButton = copyActivitiesCollectionCell.transparentButton
        cell.transparentButton.addTarget(self, action: Selector(("buttonAction")) , for: UIControlEvents.touchUpInside)
        
        OperationQueue.main.addOperation {
            cell.updateCell(with: self.activities[indexPath.row])
            self.activities[indexPath.row].imageview = cell.activityImageView.image
            

        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.detailView.selectedActivity = self.activities[indexPath.row]
        self.detailView.closeButton.addTarget(self, action: #selector(dismissView), for: .allTouchEvents)
        self.view.addSubview(blurEffectView)
        self.view.addSubview(self.detailView)
        self.detailView.alpha = 0
        self.detailView.layer.cornerRadius = 10
        self.detailView.clipsToBounds = true
        UIView.transition(with: self.activitiesCollectionView, duration: 0.4, options: .transitionCrossDissolve, animations:{
            self.detailView.alpha = 1.0
        }) { _ in }
        

    }

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
    
    
    //Filter Actions
    
//    func filterActions() {
//        guard let teamID = UserDefaults.standard.string(forKey: "teamID") else {return}
//        let activitiesRef = ref.child(teamID).child("activities")
//        
//        whenDropDown.selectionAction = { [unowned self] (index,item) in
//            
//            if index == 0 {
//                
//                activitiesRef.observe(.value, with: { (snapshot) in
//                    
//                    var newActivites = [Activity]()
//                    
//                    for activity in snapshot.children {
//                        let item = Activity(snapshot: activity as! FIRDataSnapshot)
//                        
//                        newActivites.append(item)
//                    }
//                    
//                    OperationQueue.main.addOperation {
//                        self.activities = self.sortedActivities(newActivites)
//                        self.activitiesCollectionView.reloadData()
//                    }
//                    
//                })
//                
//            }
//            
//            if index == 1 {
//                
//                activitiesRef.observe(.value, with: { (snapshot) in
//                    
//                    var newActivites = [Activity]()
//                    
//                    for activity in snapshot.children {
//                        let item = Activity(snapshot: activity as! FIRDataSnapshot)
//                        
//                        newActivites.append(item)
//                    }
//                    
//                    OperationQueue.main.addOperation {
//                        self.activities = self.filterWeekActivities(newActivites)
//                        self.activitiesCollectionView.reloadData()
//                    }
//                    
//                })
//            }
//            
//            if index == 2 {
//                activitiesRef.observe(.value, with: { (snapshot) in
//                    
//                    var newActivites = [Activity]()
//                    
//                    for activity in snapshot.children {
//                        let item = Activity(snapshot: activity as! FIRDataSnapshot)
//
//                        newActivites.append(item)
//                    }
//                    
//                    OperationQueue.main.addOperation {
//                        self.activities = self.filterMonthActivities(newActivites)
//                        self.activitiesCollectionView.reloadData()
//                    }
//                    
//                })
//            }
//        }
//    }
    
    func buttonAction(sender:UIButton!) {
        
        
        self.present(UsersTableViewController(), animated: true, completion: nil)
        print("HELLLOOOO")
    }

    func dismissView() {

        UIView.transition(with: self.activitiesCollectionView, duration: 0.8, options: .transitionCrossDissolve, animations:{
            self.blurEffectView.removeFromSuperview()
            self.detailView.removeFromSuperview()
            self.activitiesCollectionView.alpha = 1
        }) { _ in }


    }

}
