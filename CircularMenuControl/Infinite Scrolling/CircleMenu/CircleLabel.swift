//
//  CircleLabel.swift
//  CircleMenu
//
//  Created by IOS on 08/04/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import UIKit

@IBDesignable
class CircleLabel: UILabel {

    // MARK: - Variables
    public var label: UILabel?

    public var isSelected: Bool {
        didSet {
            if oldValue != isSelected {
                self.setNeedsDisplay()
            }
        }
    }
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        isSelected = false
        
        super.init(frame: frame)
                
        isOpaque = false
        backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard label != nil else {
            return
        }

         if isSelected {
            // Drawing Label
            label?.draw(rect)
            
         } else {
            label?.draw(rect)
        }
        
    }

}
