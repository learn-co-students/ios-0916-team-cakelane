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
        contentView.backgroundColor = UIColor.blue
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
