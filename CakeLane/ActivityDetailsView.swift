//
//  ActivityDetailsView.swift
//  CakeLane
//
//  Created by Rama Milaneh on 11/26/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import UIKit

class ActivityDetailsView: UIView {
   
    @IBOutlet var contentView: UIView!
    var activityImageView: UIImageView!
    var closeButton : UIButton!
    var nameLabel = UILabel()
    var activityOverlay = UIView()
    var numberOfAttendeesLabel = UILabel()
    var firstProfileImage = UIImageView()
    var secondProfileImage = UIImageView()
    var thirdProfileImage = UIImageView()
    var locationTitlelabel = UILabel()
    var locationLabel = UILabel()
    var selectedActivity: Activity! {
        
        didSet {
        //  activityImageView.image = selectedActivity.imageview
          nameLabel.text = selectedActivity.name
         locationLabel.text = selectedActivity.location
         
            
        }
        
    
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ActivityDetailsView", owner: self, options: nil)
       contentView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentView)
        contentView.constrainEdges(to: self)
        contentView.backgroundColor = UIColor.black
        setupImageView()
        setupCloseButton()
        setupActivityOverLay()
        setupLabel()

    }
    
    func setupImageView() {
    self.activityImageView = UIImageView()
     self.contentView.addSubview(activityImageView)
     self.activityImageView.translatesAutoresizingMaskIntoConstraints = false
        self.activityImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.activityImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        self.activityImageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.4).isActive = true
        self.activityImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.activityImageView.backgroundColor = UIColor.clear
        self.activityImageView.contentMode = .scaleAspectFill
        self.activityImageView.clipsToBounds = true
        self.activityImageView.image = UIImage(named: "snow")
    }
    
    func setupCloseButton() {
        self.closeButton = UIButton()
        self.contentView.addSubview(closeButton)
        self.closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.closeButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant:20.0).isActive = true
        self.closeButton.leftAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leftAnchor).isActive = true
        self.closeButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.1, constant: 0.0).isActive = true
        self.closeButton.heightAnchor.constraint(equalTo: self.closeButton.widthAnchor).isActive = true
        self.closeButton.setTitle("X", for: .normal)
        self.closeButton.setTitleColor(UIColor.white, for: .normal)
        self.closeButton.backgroundColor = UIColor.clear
        
           }
    
    func setupLabel() {
        
        self.activityImageView.addSubview(nameLabel)
        nameLabel.font = UIFont(name: "TrebuchetMS-Bold", size: 26)
        nameLabel.textColor = UIColor.white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leftAnchor, constant: 10).isActive = true
        self.nameLabel.bottomAnchor.constraint(equalTo: self.activityImageView.bottomAnchor, constant: -20).isActive = true
        
        self.contentView.addSubview(locationTitlelabel)
         locationTitlelabel.text = "Location"
        locationTitlelabel.font = UIFont(name: "TrebuchetMS-Bold", size: 20)
        locationTitlelabel.textColor = UIColor.orange
        locationTitlelabel.translatesAutoresizingMaskIntoConstraints = false
        locationTitlelabel.leftAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leftAnchor, constant: 10).isActive = true
        locationTitlelabel.topAnchor.constraint(equalTo: self.activityOverlay.bottomAnchor, constant: 10).isActive = true
       
        
        self.contentView.addSubview(locationLabel)
        locationLabel.font = UIFont(name: "TrebuchetMS-Bold", size: 20)
        locationLabel.textColor = UIColor.black
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.leftAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leftAnchor, constant: 10).isActive = true
        locationLabel.topAnchor.constraint(equalTo: self.locationTitlelabel.bottomAnchor).isActive = true
        locationLabel.backgroundColor = UIColor.white
        locationLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20).isActive = true
        locationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        locationLabel.layer.cornerRadius = 10
        locationLabel.layer.borderWidth = 1
        locationLabel.clipsToBounds = true
        

     }
    
    
    func setupActivityOverLay() {
        
        self.contentView.addSubview(activityOverlay)
        activityOverlay.backgroundColor = UIColor.white
        activityOverlay.layer.borderWidth = 1
        activityOverlay.layer.borderColor = UIColor.lightGray.cgColor
        activityOverlay.translatesAutoresizingMaskIntoConstraints = false
        activityOverlay.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        activityOverlay.topAnchor.constraint(equalTo: activityImageView.bottomAnchor).isActive = true
        activityOverlay.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        activityOverlay.heightAnchor.constraint(equalTo: self.activityImageView.heightAnchor, multiplier: 0.12).isActive = true
        
        activityOverlay.addSubview(numberOfAttendeesLabel)
        numberOfAttendeesLabel.text = "10 Attending"
        numberOfAttendeesLabel.font = UIFont(name: "TrebuchetMS-Bold", size: 12)
        numberOfAttendeesLabel.textColor = UIColor.black
        numberOfAttendeesLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfAttendeesLabel.topAnchor.constraint(equalTo: self.activityOverlay.topAnchor, constant: 10).isActive = true
        numberOfAttendeesLabel.rightAnchor.constraint(equalTo: self.activityOverlay.rightAnchor, constant: -20).isActive = true


        addSubViewToOverlay(profileImage: firstProfileImage)
        addSubViewToOverlay(profileImage: secondProfileImage)
        addSubViewToOverlay(profileImage: thirdProfileImage)
        
        firstProfileImage.leftAnchor.constraint(equalTo: self.activityImageView.layoutMarginsGuide.leftAnchor, constant: 5).isActive = true
        secondProfileImage.leftAnchor.constraint(equalTo: self.firstProfileImage.rightAnchor, constant: 3).isActive = true
        thirdProfileImage.leftAnchor.constraint(equalTo: self.secondProfileImage.rightAnchor, constant: 3).isActive = true
        
    }
    
    func addSubViewToOverlay(profileImage: UIImageView) {
        activityOverlay.addSubview(profileImage)
        profileImage.backgroundColor = UIColor.green
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.cornerRadius = 15
        profileImage.clipsToBounds = true
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.topAnchor.constraint(equalTo: self.activityOverlay.topAnchor, constant: 1.5).isActive = true
        profileImage.widthAnchor.constraint(equalTo: self.activityOverlay.widthAnchor, multiplier: 1/12).isActive = true
        profileImage.heightAnchor.constraint(equalTo: self.activityOverlay.heightAnchor, multiplier: 1/1.1).isActive = true
    }
    
    func customizeLabel(label: UILabel) {
        label.font = UIFont(name: "TrebuchetMS-Bold", size: 20)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leftAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leftAnchor, constant: 10).isActive = true
    }
    
}

extension UIView {
    func constrainEdges(to view: UIView) {
        leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
   

}
