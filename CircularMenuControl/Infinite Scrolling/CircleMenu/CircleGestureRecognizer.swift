
//
//  CircleGestureRecognizer.swift
//  CircularMenuDemo
//
//  Created by IOS on 08/04/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

class CircleGestureRecognizer: UIGestureRecognizer {
    
    // MARK: - Variables
    private let DECELERATION_MULTIPLIER: Double = 30
    
    private var previousTouchDate: Date?
    private var currentTransformAngle: CGFloat?
    
    public var isEnded: Bool?
    public var rotation: CGFloat?
    public var controlPoint: CGPoint?
    public var currentThumb: CircleThumb?
    
    // MARK: - Touch-delivery methods on UIResponder
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let view = self.view as! Circle
        let touch = touches.first
        let point = touch?.location(in: view)
        
        // Fail when more than 1 finger detected.
        if event!.touches(for: self)!.count > 1 || view.path!.contains(point!) {
            self.state = .failed
        }
        self.isEnded = false
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.state == .possible {
            state = .began
        }
        else {
            state = .changed
        }
        
        let view = self.view as! Circle
        if !view.isRotate {
            return
        }
        
        // We can look at any touch object since we know we
        // have only 1. If there were more than 1 then
        // touchesBegan:withEvent: would have failed the recognizer.
        let touch = touches.first
        
        // To rotate with one finger, we simulate a second finger.
        // The second figure is on the opposite side of the virtual
        // circle that represents the rotation gesture.
        let center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        let currentTouchPoint = touch?.location(in: view)
        let previousTouchPoint = touch?.previousLocation(in: view)
        
        previousTouchDate = Date()
        
        let angleInRadians: CGFloat = atan2(currentTouchPoint!.y - center.y, currentTouchPoint!.x - center.x) - atan2(previousTouchPoint!.y - center.y, previousTouchPoint!.x - center.x)
        self.rotation = angleInRadians
        currentTransformAngle = atan2(view.transform.b, view.transform.a)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let view = self.view as! Circle
        
        // Perform final check to make sure a tap was not misinterpreted.
        if self.state == .changed {
            let view = self.view as! Circle
            
            for thumb in view.thumbs {
                let thumb = thumb as! CircleThumb
                
                let point = thumb.convert(thumb.centerPoint!, to: nil)
                let shadow: CircleThumb = view.overlayView!.overlayThumb!
                let shadowRect: CGRect = shadow.superview!.convert(shadow.frame, to: nil)
                
                if shadowRect.contains(point) {
                    let deltaAngle: CGFloat = -CircleThumb.radiansFrom(degrees: 90) + atan2(view.transform.a, view.transform.b) + atan2(thumb.transform.a, thumb.transform.b)
                    
                    let current = view.transform
                    
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
                        view.transform = current.rotated(by: deltaAngle)
                    })
                    
                    self.currentThumb?.iconView!.isSelected = false
                    thumb.iconView!.isSelected = true
                    self.currentThumb?.iconLabel!.isSelected = false
                    thumb.iconLabel!.isSelected = true

                    view.delegate?.circle(view, didMoveTo: thumb.tag, thumb: thumb, previousThumb: self.currentThumb!)

                    self.currentThumb = thumb

                    self.isEnded = true
                    break
                }
                
            }
            
            currentTransformAngle = 0
            state = .ended
        }
        else {
            let touch = touches.first
            
            // Circle rotation animation code, to move selected thumb to center position
            for thumb in view.thumbs {
                let thumb = thumb as! CircleThumb
                let touchPoint = touch?.location(in: thumb)
                if thumb.arc!.cgPath.contains(touchPoint!) {
                    let deltaAngle: CGFloat = -CircleThumb.radiansFrom(degrees: 90) + atan2(view.transform.a, view.transform.b) + atan2(thumb.transform.a, thumb.transform.b)
                    
                    let current = view.transform
                    
                    UIView.animate(withDuration: 0.5, animations: {
                        view.transform = current.rotated(by: deltaAngle)
                    }, completion: { (finished: Bool) in
                        self.currentThumb?.iconView!.isSelected = false
                        thumb.iconView!.isSelected = true
                        self.currentThumb?.iconLabel!.isSelected = false
                        thumb.iconLabel!.isSelected = true

                        view.delegate?.circle(view, didMoveTo: thumb.tag, thumb: thumb, previousThumb: self.currentThumb!)
                        
                        self.currentThumb = thumb

                        self.isEnded = true
                    })
                    
                    break
                }
            }
            
            self.state = .failed
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.state = .failed
    }
    
}
