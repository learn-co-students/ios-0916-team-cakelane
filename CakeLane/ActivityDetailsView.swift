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
    var selectedActivity: Activity! {
        
        didSet {
          // activityImageView.image = selectedActivity.imageview
           dateLabel.text = selectedActivity.name
            
        }
        
    
    }
    var dateLabel = UILabel()
    
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
        setypLabel()
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
        self.closeButton.setTitleColor(UIColor.gray, for: .normal)
        self.closeButton.backgroundColor = UIColor.clear
        
           }
    
    func setypLabel() {
        self.activityImageView.addSubview(dateLabel)
        dateLabel.font = UIFont(name: "TrebuchetMS-Bold", size: 26)
        dateLabel.textColor = UIColor.white
        self.dateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.dateLabel.bottomAnchor.constraint(equalTo: self.activityImageView.bottomAnchor, constant: -20).isActive = true
        self.dateLabel.leftAnchor.constraint(equalTo: self.activityImageView.layoutMarginsGuide.leftAnchor, constant: 10).isActive = true
      
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
