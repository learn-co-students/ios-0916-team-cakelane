//
//  ReportButton.swift
//  CakeLane
//
//  Created by Rama Milaneh on 12/13/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import UIKit

class ReportButton: UIButton {

    override func draw(_ rect: CGRect) {
        ReportButtonView.draw(frame: bounds, resizing: .aspectFill)
    }

}
