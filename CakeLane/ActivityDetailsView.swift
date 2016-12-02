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
    var closeButton = UIButton()
    var editButton =  UIButton()
    var joinButton = UIButton()
    var nameLabel = UILabel()
    var activityOverlay = UIView()
    var numberOfAttendeesLabel = UILabel()
    var firstProfileImage = UIImageView()
    var secondProfileImage = UIImageView()
    var thirdProfileImage = UIImageView()
    var locationTitlelabel = UILabel()
    var locationLabel = UILabel()
    var dateTitlelabel = UILabel()
    var dateLabel = UILabel()
    var descriptionTitlelabel = UILabel()
    var descriptionTextView = UITextView()
    var selectedActivity: Activity! {
        
        didSet {
            OperationQueue.main.addOperation {
                self.activityImageView.image = self.selectedActivity.imageview
                self.nameLabel.text = self.selectedActivity.name
                self.locationLabel.text = "  \(self.selectedActivity.location)"
                self.dateLabel.text = "  \(self.selectedActivity.date)"
                self.dateLabel.text = "  \(self.selectedActivity.date)"
                self.descriptionTextView.text = "  \(self.selectedActivity.description)"
            }
            
            
            
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
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.constrainEdges(to: self)
        contentView.backgroundColor = UIColor(red: 25/255, green: 15/255, blue: 8/255, alpha: 0.5)
        setupImageView()
        setupCloseButton()
        setupEditButton()
        setupJoinButton()
        setupActivityOverLay()
        setupLabel()
        
    }
    
    func setupImageView() {
        
        self.activityImageView = UIImageView()
        self.contentView.addSubview(activityImageView)
        self.activityImageView.translatesAutoresizingMaskIntoConstraints = false
        self.activityImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
        self.activityImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
        self.activityImageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.45).isActive = true
        self.activityImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.activityImageView.backgroundColor = UIColor.clear
        self.activityImageView.contentMode = .scaleAspectFill
        self.activityImageView.clipsToBounds = true
    }
    
    func setupCloseButton() {
        
        self.contentView.addSubview(closeButton)
        self.closeButton.translatesAutoresizingMaskIntoConstraints = false
        self.closeButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant:20.0).isActive = true
        self.closeButton.leftAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leftAnchor).isActive = true
        self.closeButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.1, constant: 0.0).isActive = true
        self.closeButton.heightAnchor.constraint(equalTo: self.closeButton.widthAnchor).isActive = true
        self.closeButton.setTitle("X", for: .normal)
        self.closeButton.setTitleColor(UIColor.black, for: .normal)
        self.closeButton.backgroundColor = UIColor.clear
        
    }
    
    func setupEditButton() {
        
        self.contentView.addSubview(editButton)
        self.editButton.translatesAutoresizingMaskIntoConstraints = false
        self.editButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant:20.0).isActive = true
        self.editButton.rightAnchor.constraint(equalTo: self.activityImageView.layoutMarginsGuide.rightAnchor, constant: +5).isActive = true
        self.editButton.widthAnchor.constraint(equalTo: self.activityImageView.widthAnchor, multiplier: 0.06, constant: 0.0).isActive = true
        self.editButton.heightAnchor.constraint(equalTo: self.editButton.widthAnchor).isActive = true
        let image = UIImage(named: "Edit2")?.tint(color: .orange)
        self.editButton.setImage(image, for: .normal)
        
    }
    
    func setupJoinButton(){
        
        self.joinButton = UIButton()
        self.contentView.addSubview(joinButton)
        self.joinButton.translatesAutoresizingMaskIntoConstraints = false
        self.joinButton.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant:-30.0).isActive = true
        self.joinButton.rightAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.rightAnchor, constant: -0.75*self.contentView.center.x).isActive = true
        self.joinButton.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 0.75*self.contentView.center.x).isActive = true
        self.joinButton.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.joinButton.setTitle("Join Us!!!", for: .normal)
        self.joinButton.setTitleColor(UIColor.darkGray, for: .normal)
        self.joinButton.layer.borderWidth = 1
        self.joinButton.clipsToBounds = true
        self.joinButton.layer.cornerRadius = 10
        self.joinButton.backgroundColor = UIColor.orange
    }
    
    func setupLabel() {
        
        self.activityImageView.addSubview(nameLabel)
        nameLabel.font = UIFont(name: "TrebuchetMS-Bold", size: 20)
        nameLabel.textColor = UIColor.white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leftAnchor, constant: 10).isActive = true
        self.nameLabel.bottomAnchor.constraint(equalTo: self.activityImageView.bottomAnchor, constant: -20).isActive = true
        
        self.setupTitleLabel(titleLabel: locationTitlelabel)
        locationTitlelabel.text = "Location"
        locationTitlelabel.topAnchor.constraint(equalTo: self.activityOverlay.bottomAnchor, constant: 10).isActive = true
        
        self.setupTitleLabel(titleLabel: dateTitlelabel)
        dateTitlelabel.text = "Date"
        dateTitlelabel.topAnchor.constraint(equalTo: self.locationLabel.bottomAnchor, constant: 10).isActive = true
        
        self.setupTitleLabel(titleLabel: descriptionTitlelabel)
        descriptionTitlelabel.text = "Description"
        descriptionTitlelabel.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: 10).isActive = true
        
        self.setupLabel(label: locationLabel)
        locationLabel.topAnchor.constraint(equalTo: self.locationTitlelabel.bottomAnchor).isActive = true
        
        self.setupLabel(label: dateLabel)
        dateLabel.topAnchor.constraint(equalTo: self.dateTitlelabel.bottomAnchor).isActive = true
        
        
        self.contentView.addSubview(descriptionTextView)
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.leftAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leftAnchor, constant: 10).isActive = true
        descriptionTextView.topAnchor.constraint(equalTo: self.descriptionTitlelabel.bottomAnchor).isActive = true
        descriptionTextView.backgroundColor = UIColor.white
        descriptionTextView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20).isActive = true
        descriptionTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        descriptionTextView.font = UIFont(name: "TrebuchetMS-Bold", size: 14)
        descriptionTextView.clipsToBounds = true
        descriptionTextView.layer.cornerRadius = 5
        descriptionTextView.backgroundColor = UIColor.white
        descriptionTextView.textColor = UIColor.black
        descriptionTextView.isScrollEnabled = true
        descriptionTextView.isEditable = false
        
        
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
        activityOverlay.heightAnchor.constraint(equalTo: self.activityImageView.heightAnchor, multiplier: 0.14).isActive = true
        
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
        profileImage.layer.cornerRadius = 17
        profileImage.clipsToBounds = true
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.topAnchor.constraint(equalTo: self.activityOverlay.topAnchor, constant: 1.8).isActive = true
        profileImage.widthAnchor.constraint(equalTo: self.activityOverlay.widthAnchor, multiplier: 1/12).isActive = true
        profileImage.heightAnchor.constraint(equalTo: self.activityOverlay.heightAnchor, multiplier: 1/1.2).isActive = true
    }
    
    
    func setupTitleLabel( titleLabel:UILabel) {
        
        self.contentView.addSubview(titleLabel)
        titleLabel.font = UIFont(name: "TrebuchetMS-Bold", size: 20)
        titleLabel.textColor = UIColor.orange
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leftAnchor, constant: 10).isActive = true
        
    }
    
    func setupLabel(label: UILabel) {
        
        self.contentView.addSubview(label)
        label.font = UIFont(name: "TrebuchetMS-Bold", size: 14)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leftAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leftAnchor, constant: 10).isActive = true
        label.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20).isActive = true
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        label.backgroundColor = UIColor.white
        label.layer.cornerRadius = 5
        label.layer.borderWidth = 1
        label.clipsToBounds = true
        
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

// extension to change the color of image
extension UIImage {
    
    func tint(color: UIColor) -> UIImage? {
        
        let drawRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else {return nil}
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.clip(to: drawRect, mask: self.cgImage!)
        color.setFill()
        UIRectFill(drawRect)
        draw(in: drawRect, blendMode: .overlay, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage
        
    }
    
}
