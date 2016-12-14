//
//  EditButton.swift
//  CakeLane
//
//  Created by Rama Milaneh on 12/13/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import UIKit

class EditButton: UIButton {

    override func draw(_ rect: CGRect) {
        EditButtonView.drawEditButton(frame: bounds, resizing: .aspectFill)
    }

}
