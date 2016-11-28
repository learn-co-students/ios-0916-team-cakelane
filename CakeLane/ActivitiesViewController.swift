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
    let activitiesRef = FIRDatabase.database().reference(withPath: "activities")

    var isAnimating: Bool = false
    var dropDownViewIsDisplayed: Bool = false

    override func viewDidLoad() {

        super.viewDidLoad()

        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        navigationItem.title = "Best App"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false


        let frame = CGRect(x: 0.05*self.view.frame.maxX, y: 0.05*self.view.frame.maxY, width: self.view.frame.width*0.9, height: self.view.frame.height*0.81)

        self.detailView = ActivityDetailsView(frame: frame)

        setUpActivityCollectionCells()
        createLayout()

        self.activitiesRef.observe(.value, with: { (snapshot) in

            var newActivites = [Activity]()

            for activity in snapshot.children {
                let item = Activity(snapshot: activity as! FIRDataSnapshot)

                // MARK: make sure incoming acitivity (firebase) has all of the desired properties (version issue)
//                print("********************")
//                dump(item)
//                print("********************")
                newActivites.append(item)


            }
            self.activities = self.sortedActivities(newActivites)
            OperationQueue.main.addOperation {

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

}
