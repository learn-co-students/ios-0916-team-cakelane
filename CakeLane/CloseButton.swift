//
//  CloseButton.swift
//  CakeLane
//
//  Created by Rama Milaneh on 12/13/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import UIKit

class CloseButton: UIButton {

    override func draw(_ rect: CGRect) {
        
        CloseButtonView.draw(frame: bounds, resizing: .aspectFill)
    }

}
