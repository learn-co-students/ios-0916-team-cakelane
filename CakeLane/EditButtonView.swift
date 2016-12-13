//
//  EditButtonView.swift
//  CakeLane
//
//  Created by Rama Milaneh on 12/13/16.
//  Copyright © 2016 FlatironSchool. All rights reserved.
//

import Foundation
import UIKit


public class EditButtonView : NSObject {
    //// Drawing Methods
    public dynamic class func drawEditButton(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 200, height: 200), resizing: ResizingBehavior = .aspectFit) {
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
        //// Group
        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 32.5, y: 29.5, width: 136, height: 138))
        color2.setFill()
        ovalPath.fill()
        color.setStroke()
        ovalPath.lineWidth = 5
        ovalPath.stroke()
        //// Rectangle Drawing
        context.saveGState()
        context.translateBy(x: 116.46, y: 59.43)
        context.rotate(by: 38.45 * CGFloat.pi/180)
        let rectanglePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 23.79, height: 12.07))
        color.setFill()
        rectanglePath.fill()
        context.restoreGState()
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 105.8, y: 73.04))
        bezierPath.addCurve(to: CGPoint(x: 122.94, y: 87.29), controlPoint1: CGPoint(x: 105.8, y: 73.03), controlPoint2: CGPoint(x: 122.94, y: 87.29))
        bezierPath.addLine(to: CGPoint(x: 83.65, y: 136.03))
        bezierPath.addCurve(to: CGPoint(x: 83.51, y: 136.41), controlPoint1: CGPoint(x: 83.51, y: 136.23), controlPoint2: CGPoint(x: 83.51, y: 136.41))
        bezierPath.addLine(to: CGPoint(x: 66.89, y: 136.41))
        bezierPath.addCurve(to: CGPoint(x: 66.89, y: 122.09), controlPoint1: CGPoint(x: 66.89, y: 136.41), controlPoint2: CGPoint(x: 66.89, y: 125.02))
        bezierPath.addCurve(to: CGPoint(x: 66.5, y: 121.77), controlPoint1: CGPoint(x: 66.64, y: 121.88), controlPoint2: CGPoint(x: 66.5, y: 121.77))
        bezierPath.addCurve(to: CGPoint(x: 66.77, y: 121.43), controlPoint1: CGPoint(x: 66.55, y: 121.7), controlPoint2: CGPoint(x: 66.77, y: 121.43))
        bezierPath.addCurve(to: CGPoint(x: 104.47, y: 74.68), controlPoint1: CGPoint(x: 66.85, y: 121.33), controlPoint2: CGPoint(x: 104.47, y: 74.68))
        bezierPath.addCurve(to: CGPoint(x: 105.8, y: 73.03), controlPoint1: CGPoint(x: 105.32, y: 73.63), controlPoint2: CGPoint(x: 105.8, y: 73.03))
        bezierPath.addLine(to: CGPoint(x: 105.8, y: 73.04))
        bezierPath.close()
        color.setFill()
        bezierPath.fill()
        
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
