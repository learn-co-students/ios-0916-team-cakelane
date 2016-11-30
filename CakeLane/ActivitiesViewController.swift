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

class ActivitiesViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var activitiesCollectionView: UICollectionView!
    var activities = [Activity]()
    var blurEffectView: UIVisualEffectView!
    var detailView: ActivityDetailsView!
    let ref = FIRDatabase.database().reference()
    var selectedActivity: Activity?
    
    var isAnimating: Bool = false
    var dropDownViewIsDisplayed: Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        guard let teamID = UserDefaults.standard.string(forKey: "teamID") else {return}
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        navigationItem.title = "Best App"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        
        
        let frame = CGRect(x: 0.05*self.view.frame.maxX, y: 0.03*self.view.frame.maxY, width: self.view.frame.width*0.9, height: self.view.frame.height*0.85)
        
        self.detailView = ActivityDetailsView(frame: frame)
        
        
        
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
        OperationQueue.main.addOperation {
            cell.updateCell(with: self.activities[indexPath.row])
            self.activities[indexPath.row].imageview = cell.activityImageView.image
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedActivity = self.activities[indexPath.row]
        
        guard let teamID = UserDefaults.standard.string(forKey: "teamID") else {return}

        let activitiesRef = ref.child(teamID).child("activities").child((selectedActivity?.id)!)
        
        activitiesRef.observe(.value, with: { (snapshot) in
             self.detailView.selectedActivity = Activity(snapshot: snapshot )
        

        //self.detailView.selectedActivity = self.activities[indexPath.row]
        self.detailView.closeButton.addTarget(self, action: #selector(self.dismissView), for: .allTouchEvents)
        self.view.addSubview(self.blurEffectView)
        self.view.addSubview(self.detailView)
        guard let slackID = UserDefaults.standard.string(forKey: "slackID") else {return}
        if self.detailView.selectedActivity.owner == slackID {
            self.detailView.editButton.isHidden = false
            self.detailView.editButton.addTarget(self, action: #selector(self.editSelectedActivity), for: .allTouchEvents)
            
        }else{
            self.detailView.editButton.isHidden = true
        }
                })
        self.detailView.alpha = 0
        self.detailView.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: 0.5        , animations: {
            self.detailView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.detailView.alpha = 1
        });

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
        if segue.identifier == "editActivity" && !self.detailView.editButton.isHidden  {
            let dest = segue.destination as! AddActivityController
            dest.selectedActivity = self.selectedActivity
        }
    }
}
