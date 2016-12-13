//
//  CloseButtonView.swift
//  CakeLane
//
//  Created by Rama Milaneh on 12/13/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import Foundation
import UIKit

public class CloseButtonView : NSObject {
    //// Drawing Methods
    public dynamic class func draw(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 200, height: 200), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 200, height: 200), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 200, y: resizedFrame.height / 200)
        //// Color Declarations
//        let color = UIColor(red: 0.858, green: 0.464, blue: 0.299, alpha: 1.000)
        let color = UIColor.orange

        let color2 = UIColor(red: 0.289, green: 0.255, blue: 0.249, alpha: 1.000)
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 32.5, y: 29.5, width: 136, height: 138))
        color2.setFill()
        ovalPath.fill()
        color.setStroke()
        ovalPath.lineWidth = 5
        ovalPath.stroke()
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 72.5, y: 71.5))
        bezierPath.addCurve(to: CGPoint(x: 130.5, y: 129.5), controlPoint1: CGPoint(x: 130.51, y: 129.51), controlPoint2: CGPoint(x: 130.5, y: 129.5))
        color.setStroke()
        bezierPath.lineWidth = 5
        bezierPath.stroke()
        //// Bezier 2 Drawing
        context.saveGState()
        context.translateBy(x: 72.5, y: 129.5)
        context.rotate(by: -90 * CGFloat.pi/180)
        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 0, y: 0))
        bezier2Path.addCurve(to: CGPoint(x: 58, y: 58), controlPoint1: CGPoint(x: 58.01, y: 58.01), controlPoint2: CGPoint(x: 58, y: 58))
        color.setStroke()
        bezier2Path.lineWidth = 5
        bezier2Path.stroke()
        context.restoreGState()
        
        context.restoreGState()
    }
    @objc public enum ResizingBehavior: Int {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.
        public func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }
            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)
            switch self {
            case .aspectFit:
                scales.width = min(scales.width, scales.height)
                scales.height = scales.width
            case .aspectFill:
                scales.width = max(scales.width, scales.height)
                scales.height = scales.width
            case .stretch:
                break
            case .center:
                scales.width = 1
                scales.height = 1
            }
            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
}
