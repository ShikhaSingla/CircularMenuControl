
//
//  CircleOverlayView.swift
//  CircularMenuDemo
//
//  Created by IOS on 08/04/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import UIKit

class CircleOverlayView: UIView {
    
    // MARK: - Variables
    public var overlayThumb: CircleThumb!
    public var circle: Circle?
    public var controlPoint: CGPoint?
    public var buttonCenter: CGPoint?
    public var iconView: CircleIconView!

    public var circularMenuOptions = [String]()
    
    open override var center: CGPoint {
        didSet {
            self.circle?.center = buttonCenter!
        }
    }

    // MARK: - Initialization
    required init?(with circle: Circle, arr: [String]) {

        
        if !circle.isRotate {
            fatalError("init(with:) called for non-rotating circle")
        }
        
        let frame = circle.frame
        super.init(frame: frame)
        
        // Add observer to update selected value
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(doThisWhenNotify),
                                               name: NSNotification.Name(rawValue: "Value selected"),
                                               object: nil)

        self.isOpaque = false
        self.circle = circle
        self.circle?.overlayView = self
        
        var rect1 = CGRect(x: 0, y: 0, width: self.circle!.frame.height - (2*circle.ringWidth), height: self.circle!.frame.width - (2*circle.ringWidth))
        rect1.origin.x = self.circle!.frame.size.width/2 - rect1.size.width/2
        rect1.origin.y = 0
        
        overlayThumb = CircleThumb(with: rect1.size.height/2, longRadius: self.circle!.frame.size.height/2+10, numberOfSegments: self.circle!.numberOfSegments)
        overlayThumb?.isGradientFill = false
        
        overlayThumb?.layer.position = CGPoint(x: 470, y: 275)
        overlayThumb.transform = CGAffineTransform(rotationAngle: .pi/2)
        
        overlayThumb?.arcColor = UIColor(red: 248/255, green: 229/255, blue: 228/255, alpha: 1.0)
        
        /** Selected Value on Overlay thumb **/
        // middle index of visible items, currently 7 items are visible at a time
        overlayThumb.iconLabel.text = arr[3]
        overlayThumb.iconLabel.textColor = UIColor(red: 81/255, green: 92/255, blue: 97/255, alpha: 1.0)
        overlayThumb.iconLabel.numberOfLines = 2
        overlayThumb.iconLabel.textAlignment = .center
        overlayThumb.iconLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)

        self.controlPoint = overlayThumb?.layer.position
        self.addSubview(overlayThumb!)

        self.buttonCenter = CGPoint(x: frame.midX, y: circle.frame.midY)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
    
    // MARK: - Notification Observer Method
    @objc func doThisWhenNotify(notification:Notification) {
        
        guard let name = notification.userInfo!["name"] else { return }
        overlayThumb.iconLabel.text = name as? String
    }
}
