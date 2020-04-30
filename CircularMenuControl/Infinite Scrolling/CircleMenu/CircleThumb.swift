
//
//  CircleThumb.swift
//  CircularMenuDemo
//
//  Created by IOS on 08/04/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import UIKit

class CircleThumb: UIView {
    
    enum CGGradientPosition {
        case vertical
        case horizontal
    }
    
    // MARK: - Variables
    static let kIconViewWidth: CGFloat =  100
    static let kIconViewHeight: CGFloat = 30
    
    private var numberOfSegments: CGFloat
    //    private var bigArcHeight: CGFloat
    //    private var smallArcWidth: CGFloat
    
    public let sRadius: CGFloat
    public let lRadius: CGFloat
    //    public let yydifference: CGFloat?
    public var arc: UIBezierPath?
    public var separatorColor: UIColor?
    public var separatorStyle: Circle.ThumbSeparatorStyle
    public var centerPoint: CGPoint?
    public var colorsLocations: Array<CGFloat>?
    public var isGradientFill: Bool
    public var gradientColors = [UIColor.darkGray.cgColor, UIColor.lightText.cgColor]
    public var arcColor: UIColor?
    
    public var iconView: CircleIconView!
    public var iconLabel: CircleLabel!
    
    // MARK: - Initialization
    required init(with shortRadius: CGFloat, longRadius: CGFloat, numberOfSegments sNumber: Int, iconWidth: CGFloat = kIconViewWidth, iconHeight: CGFloat = kIconViewHeight) {
        var frame: CGRect?
        
        var width: CGFloat
        var height: CGFloat
        
        let fstartAngle: CGFloat = CGFloat(270 - ((360/sNumber)/2))
        let fendAngle: CGFloat = CGFloat(270 + ((360/sNumber)/2))
        
        let startAngle: CGFloat = CircleThumb.radiansFrom(degrees: fstartAngle)
        let endAngle: CGFloat = CircleThumb.radiansFrom(degrees: fendAngle)
        
        
        let bigArc = UIBezierPath(arcCenter: CGPoint(x: longRadius, y: longRadius), radius:longRadius, startAngle:startAngle, endAngle:endAngle, clockwise: true)
        let smallArc = UIBezierPath(arcCenter: CGPoint(x: longRadius, y: longRadius), radius:shortRadius, startAngle:startAngle, endAngle:endAngle, clockwise: true)
        
        // Start of calculations
        if ((fendAngle - fstartAngle) <= 180) {
            width = bigArc.bounds.size.width
            height = smallArc.currentPoint.y
            frame = CGRect(x: 0, y: 0, width: width, height: height)
        }
        if ((fendAngle - fstartAngle) > 269) {
            frame = CGRect(x: 0, y: 0, width: bigArc.bounds.size.width, height: bigArc.bounds.size.height)
        }
        //End of calculations
        
        
        numberOfSegments = CGFloat(sNumber)
        sRadius = shortRadius
        lRadius = longRadius
        separatorStyle = .none
        isGradientFill = false
        
        super.init(frame: frame!)
        
        self.isOpaque = false
        self.backgroundColor = UIColor.clear
        
        let y: CGFloat = (lRadius - sRadius)/2.00
        let xi: CGFloat = 0.5
        let yi: CGFloat = y/frame!.size.height
        self.layer.anchorPoint = CGPoint(x: xi, y: yi)
        self.isGradientFill = false
        self.arcColor = .clear //UIColor(red: 255/255, green: 130/255, blue: 123/255, alpha: 1.0)

        self.centerPoint = CGPoint(x: self.bounds.midX, y: y)
        
        self.iconView = CircleIconView(frame: CGRect(x: frame!.midX, y: y, width: self.frame.width+120, height: self.frame.height-30))
        self.iconView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        self.iconView!.center = CGPoint(x: frame!.midX, y: y+40)
        self.iconView.image = UIImage(named: "vector")
        self.addSubview(self.iconView!)
                
        self.iconLabel = CircleLabel(frame: CGRect(x: frame!.midX, y: y, width: 130, height: 60))
        self.iconLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 15.0)
        self.iconLabel.textAlignment = .center
        self.iconLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        self.iconLabel!.center = CGPoint(x: frame!.midX, y: y)
        self.addSubview(self.iconLabel!)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        super.draw(rect)
        arcColor?.setStroke()
        arcColor?.setFill()
        
        //Angles
        let clockwiseStartAngle = CircleThumb.radiansFrom(degrees: (270 - ((360/numberOfSegments)/2)))
        let clockwiseEndAngle = CircleThumb.radiansFrom(degrees: (270 + ((360/numberOfSegments)/2)))
        
        let nonClockwiseStartAngle = clockwiseEndAngle
        let nonClockwiseEndAngle = clockwiseStartAngle
        
        let center = CGPoint(x: rect.midX, y: lRadius)
        
        arc = UIBezierPath(arcCenter: center, radius: lRadius, startAngle: clockwiseStartAngle, endAngle: clockwiseEndAngle, clockwise: true)
        let f = arc?.currentPoint
        arc?.addArc(withCenter: center, radius: sRadius, startAngle: nonClockwiseStartAngle, endAngle: nonClockwiseEndAngle, clockwise: false)
        
        let e = arc?.currentPoint
        
        arc?.close()
        
        let context = UIGraphicsGetCurrentContext()
        
        if !self.isGradientFill {
            arc?.fill()
        }
        else {
            // Gradient color code
            var la = [CGFloat]()
            let path = arc?.cgPath
            if (gradientColors.count == 2) {
                la.insert(0.00, at: 0)
                la.insert(1.00, at: 1)
            }
            else
            {
                if colorsLocations == nil {
                    for var i in (0..<gradientColors.count) {
                        let fi = gradientColors.count-1
                        let point = CGFloat(1.00)/CGFloat(fi)
                        la.insert(point*CGFloat(i), at: i)
                        i+=1
                    }
                }
                else {
                    for var i in (0..<colorsLocations!.count) {
                        la.insert(colorsLocations![i], at: i)
                        i+=1
                    }
                }
            }
            
            drawLinearGradient(context: context!, path: path!, colors: gradientColors as CFArray, position: .vertical, locations: la, rect: rect)
        }
        
        UIColor.lightGray.setStroke()
        UIColor.lightGray.setFill()
        
        
        if (self.separatorStyle != .none) {
            let line = UIBezierPath()
            if (separatorStyle == .basic) {
                line.lineWidth = 1.0;
            }
            
            
            line.move(to: f!)
            line.addLine(to: CGPoint(x: f!.x - e!.x, y: e!.y))
            separatorColor?.setStroke()
            separatorColor?.setFill()
            
            line.stroke(with: .copy, alpha: 1.00)
            line.fill(with: .copy, alpha: 1.00)
        }
        
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
    
    static func radiansFrom(degrees: CGFloat) -> CGFloat {
        return (CGFloat(Double.pi) * (degrees) / 180.0)
    }
    
    static func degreesFrom(radians: CGFloat) -> CGFloat {
        return ((radians) / CGFloat(Double.pi) * 180)
    }
    
    func drawLinearGradient(context: CGContext, path: CGPath, colors: CFArray, position: CGGradientPosition, locations: [CGFloat], rect: CGRect) {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations)
        var startPoint: CGPoint
        var endPoint: CGPoint
        
        switch (position) {
        case .horizontal:
            startPoint = CGPoint(x: rect.midX, y: rect.minY)
            endPoint = CGPoint(x: rect.midX, y: rect.maxY)
        case .vertical:
            startPoint = CGPoint(x: rect.minX, y: rect.midY)
            endPoint = CGPoint(x: rect.maxX, y: rect.midY)
        }
        
        context.saveGState()
        context.addPath(path)
        context.clip()
        context.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: 0))
        context.restoreGState()
        
        //        CGGradientRelease(gradient);
        //        CGColorSpaceRelease(colorSpace);
    }
    
    
}
