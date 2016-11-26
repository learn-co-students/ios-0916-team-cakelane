//
//  ActivityDetailView.swift
//  CakeLane
//
//  Created by Rama Milaneh on 11/25/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import UIKit

class ActivityDetailView: UIView {

    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInt()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInt()
    }
    
    func commonInt() {
        Bundle.main.loadNibNamed("ActivityDetailView", owner: self, options: nil)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.constrainEdges(to: self)
        self.addSubview(contentView)
        
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
