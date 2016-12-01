//
//  ActivitiesTableViewCell.swift
//  CakeLane
//
//  Created by Henry Chan on 11/30/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import UIKit
import Firebase

class UserTableViewCell: UITableViewCell {
    

    var profileImage = UIImageView()
    var nameLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(profileImage)
        profileImage.backgroundColor = UIColor.green
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderColor = UIColor.black.cgColor
        profileImage.layer.cornerRadius = 22
        profileImage.clipsToBounds = true
        profileImage.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(10)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.equalTo(contentView.snp.width).dividedBy(9)
            make.height.equalTo(contentView.snp.height).dividedBy(1.4)

        }
        
        contentView.addSubview(nameLabel)
        nameLabel.text = "Henry"
        nameLabel.font = UIFont(name: "TrebuchetMS-Bold", size: 12)
        nameLabel.textColor = UIColor.black
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(profileImage.snp.right).offset(15)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.equalTo(contentView.snp.width).dividedBy(12)
            make.height.equalTo(contentView.snp.height).dividedBy(1.1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func updateCell(with activity: Activity) {
        
//        self.activityLabel.text = activity.name
//        self.dateLabel.text = activity.date
//        self.locationLabel.text = activity.location
        self.profileImage.image = UIImage(named: "snow")
        
        
        // MARK: download activity image from firebase
        //        self.downloadImage(at: activity.image) { (success, image) in
        //            DispatchQueue.main.async {
        //                self.activityImageView.image = image
        //                self.setNeedsLayout()
        //            }
        //        }
        
        
    }
    
}
