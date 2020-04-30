//
//  InfiniteRotatingViewController.swift
//  CircularMenuDemo
//
//  Created by IOS on 16/04/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import UIKit

public class InfiniteRotatingViewController: UIViewController, CircleDataSource, CircleDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var btnGO: UIButton!
    
    // MARK: - Variables
    var arrMenuOptions = [String]() // Local array
    public var circularMenuOptions = [String]() // Global array

    var startIndex: Int = 0
    var endIndex: Int = 11
    var currentSelectedIndex: Int = 3 // As per middle of 7 visible options at a time
    var newSelectedIndex: Int = 0
    
    var circle: Circle!
    var circleFrame = CGRect()

    // MARK: - View Lifecycle Methods
    override public func viewDidLoad() {
        super.viewDidLoad()
                
        // Fill first 12 options in local array from global array
        for index in startIndex..<endIndex+1 {
            self.arrMenuOptions.append(circularMenuOptions[index])
        }
        
        // Create Circle View
        circleFrame = CGRect(x: -270, y: self.view.frame.midY/2-50, width: 550, height: 550)
        prepareView()
        prepareDefaultCircleMenu(frame: circleFrame)
    }
    
    // MARK: - Custom Methods
    func prepareView() {
        view.backgroundColor = UIColor.white
        btnGO.isUserInteractionEnabled = false
    }
    
    func prepareDefaultCircleMenu(frame: CGRect) {
        // Create circle
        circle = Circle(with: frame, numberOfSegments: self.arrMenuOptions.count, ringWidth: 160.0, iconWidth: 100, iconHeight: 30)
        
        // Set dataSource and delegate
        circle.dataSource = self
        circle.delegate = self
        
        // Center Go button
        btnGO.layer.position = CGPoint(x: circle.frame.midX, y: circle.frame.midY+5)
        
        // Create overlay with circle
        let overlay = CircleOverlayView(with: circle, arr: self.circularMenuOptions)
        
        // Add to view
        self.view.addSubview(circle)
        self.view.addSubview(overlay!)

        self.view.addSubview(btnGO)
    }
    
    /*
     ** As scroll moves upward/downward to current item,
     ** update the start and end index and refill items in circle from global array
    */
    func updateArray() {
        
        let indexDiff = newSelectedIndex - currentSelectedIndex
        
        startIndex = startIndex + indexDiff
        endIndex = endIndex + indexDiff
                
        self.arrMenuOptions.removeAll()
        
        if startIndex < 0 {
            if abs(startIndex) > circularMenuOptions.count {
                startIndex += circularMenuOptions.count
                endIndex += circularMenuOptions.count
            }
        } else {
            if startIndex > circularMenuOptions.count {
                startIndex -= circularMenuOptions.count
                endIndex -= circularMenuOptions.count
            }
        }
        
        if startIndex < 0 {
            let startIndexCount = abs(startIndex)
            
            var start = 0
            if endIndex < 0 {
                start = abs(endIndex)-1
            }
            for index in (start..<startIndexCount).reversed() {
                self.arrMenuOptions.append(circularMenuOptions.reversed()[index])
            }
        }
        
        if endIndex >= 0 {
            for index in max(0, startIndex)..<min(endIndex, circularMenuOptions.count-1)+1 {
                self.arrMenuOptions.append(circularMenuOptions[index])
            }

        }
        
        if endIndex >= circularMenuOptions.count {
            let endIndexCount = endIndex - circularMenuOptions.count
            for index in 0..<endIndexCount+1 {
                self.arrMenuOptions.append(circularMenuOptions[index])
            }
        }
        
        // Render the circle again
        self.prepareDefaultCircleMenu(frame: circleFrame)
    
    }
    
    // MARK: - Circle Data Source & Delegate Methods
    func circle(_ circle: Circle, didMoveTo segment: Int, thumb: CircleThumb, previousThumb: CircleThumb) {

        newSelectedIndex = segment
        updateArray()

        NotificationCenter.default.post(name: Notification.Name(rawValue: "Value selected"), object: nil, userInfo: ["name":arrMenuOptions[currentSelectedIndex]])

    }
    
    func circle(_ circle: Circle, labelForThumbAt row: Int, thumb: CircleThumb) -> UILabel {
                
        let labelMenu = UILabel(frame: CGRect(x: 0, y: 0, width: 130, height: 60))
        labelMenu.textColor = .white
        labelMenu.numberOfLines = 2
        labelMenu.textAlignment = .center
        labelMenu.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)
        labelMenu.text = arrMenuOptions[row]
        return labelMenu
    }
}


