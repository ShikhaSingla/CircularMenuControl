//
//  FiniteCollectionViewLayout.swift
//  CircularMenuDemo
//
//  Created by IOS on 16/04/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import UIKit

class FiniteCollectionViewLayout: UICollectionViewLayout {
    
    // MARK: - Variables
    var center: CGPoint = .zero
    var radius: Float = 60
    var itemSize: CGSize = .zero
    var angularSpacing: Float = 0.0
    var scrollDirection: UICollectionView.ScrollDirection = .vertical
    var mirrorX: Bool = false
    var mirrorY: Bool = false
    var rotateItems: Bool = true
    var angleOfEachItem: Float = 0.0
    var angleForSpacing: Float = 0.0
    var circumference: Float = 0.0
    var cellCount: Int = 0
    var maxNoOfCellsInCircle: Float = 0.0
    
    var startAngle: Float = 0
    var endAngle: Float = 0
    
    private var cache = [UICollectionViewLayoutAttributes]()

    // MARK: - Initialization
    override init() {
        super.init()
        self.startAngle = Float.pi
        self.endAngle = 0
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // Initialize circle layout position
    func initWithCentre(center: CGPoint, radius: Float, itemSize: CGSize, angularSpacing: Float) {
        self.center = center
        self.radius = radius
        self.itemSize = itemSize
        self.angularSpacing = angularSpacing
    }
    
    // Specifies start and end angle
    func setStartAngle(startAngle: Float, endAngle: Float) {
        self.startAngle = startAngle
        self.endAngle = endAngle
        
        if startAngle == 2*(Float.pi) {
            self.startAngle = 2*(Float.pi) - (Float.pi)/180
        }
        
        if endAngle == 2*(Float.pi) {
            self.startAngle = 2*(Float.pi) - (Float.pi)/180
        }
    }
    
    // The collection view calls -prepare once at its first layout as the first message to the layout instance.
    // The collection view calls -prepare again after layout is invalidated and before requerying the layout information.
    override func prepare() {
        super.prepare()
        
        cellCount = (self.collectionView?.numberOfItems(inSection: 0))!
        circumference = abs(self.startAngle - self.endAngle) * self.radius
        maxNoOfCellsInCircle = circumference/(max(Float(self.itemSize.width), Float(self.itemSize.height)) + self.angularSpacing)
        angleOfEachItem = abs(self.startAngle - self.endAngle)/maxNoOfCellsInCircle
        
    }
    
    // MARK: - Set Collectionview Content Size
    override var collectionViewContentSize: CGSize {
        
        let visibleAngle: Float = abs(self.startAngle - self.endAngle)
        let remainingItemsCount: Int = cellCount > Int(maxNoOfCellsInCircle) ? cellCount - Int(maxNoOfCellsInCircle) : 0
        let scrollableContentWidth: Float = Float(remainingItemsCount+1) * angleOfEachItem * self.radius/((2*(Float.pi))/visibleAngle)
        let height: Float = self.radius + (max(Float(self.itemSize.width), Float(self.itemSize.height))/2)
        
        if self.scrollDirection == UICollectionView.ScrollDirection.vertical {
            return CGSize(width: CGFloat(height), height: CGFloat(scrollableContentWidth) + (self.collectionView?.bounds.size.height)!)
        }
        
        return CGSize(width: CGFloat(scrollableContentWidth) + (self.collectionView?.bounds.size.width)!, height: CGFloat(height))
    }
    
    // MARK: - Custom Methods
    func layoutAttributesForHorozontalScrollForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        
        var offset: Float = Float((self.collectionView?.contentOffset.x)!)
        offset = offset == 0 ? 1 : offset
        
        let offsetPartInMPI: Float = offset/circumference
        let angle: Float = 2*(Float.pi)*offsetPartInMPI
        let offsetAngle: Float = angle
        
        attributes.size = self.itemSize
        let mirrorX: Int = self.mirrorX ? -1 : 1
        let mirrorY: Int = self.mirrorY ? -1 : 1
        
        let cosFunc = cosf(Float(indexPath.item) * angleOfEachItem - offsetAngle + (angleOfEachItem/2) - self.startAngle)
        let x: Float = Float(self.center.x) + offset + (Float(mirrorX) * self.radius * cosFunc)
        
        let sinFunc = sinf(Float(indexPath.item) * angleOfEachItem - offsetAngle + (angleOfEachItem/2) - self.startAngle)
        let y: Float = Float(self.center.y) + (Float(mirrorY) * self.radius * sinFunc)
        
        let cellCurrentAngle: Float = (Float(indexPath.item) * angleOfEachItem) + angleOfEachItem/2 - offsetAngle
        
        if (cellCurrentAngle >= -angleOfEachItem/2) && (cellCurrentAngle <= abs(self.startAngle - self.endAngle) + angleOfEachItem/2) {
            attributes.alpha = 1
        } else {
            attributes.alpha = 0
        }
        
        attributes.center = CGPoint(x: CGFloat(x), y: CGFloat(y))
        attributes.zIndex = Int(cellCount) - indexPath.item
        
        if self.rotateItems {
            if self.mirrorY {
                attributes.transform = CGAffineTransform(rotationAngle: CGFloat(Float.pi - cellCurrentAngle - (Float.pi/2)))
            } else {
                attributes.transform = CGAffineTransform(rotationAngle: CGFloat(cellCurrentAngle - (Float.pi/2)))
            }
        }
        
        return attributes
    }
    
    func layoutAttributesForVerticalScrollForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        
        var offset: Float = Float((self.collectionView?.contentOffset.y)!)
        offset = offset == 0 ? 1 : offset
        
        let offsetPartInMPI: Float = offset/circumference
        let angle: Float = 2*(Float.pi)*offsetPartInMPI
        let offsetAngle: Float = angle
        
        attributes.size = self.itemSize
        let mirrorX: Int = self.mirrorX ? -1 : 1
        let mirrorY: Int = self.mirrorY ? -1 : 1
        
        let cosFunc = cosf(Float(indexPath.item) * angleOfEachItem - offsetAngle + (angleOfEachItem/2) - self.startAngle)
        let x: Float = Float(self.center.x) + (Float(mirrorX) * self.radius * cosFunc)
        
        let sinFunc = sinf(Float(indexPath.item) * angleOfEachItem - offsetAngle + (angleOfEachItem/2) - self.startAngle)
        let y: Float = Float(self.center.y) + offset + (Float(mirrorY) * self.radius * sinFunc)
        
        let cellCurrentAngle: Float = (Float(indexPath.item) * angleOfEachItem) + angleOfEachItem/2 - offsetAngle
        
        if (cellCurrentAngle >= -angleOfEachItem/2) && (cellCurrentAngle <= abs(self.startAngle - self.endAngle) + angleOfEachItem/2) {
            attributes.alpha = 1
        } else {
            attributes.alpha = 0
        }
        
        attributes.center = CGPoint(x: CGFloat(x), y: CGFloat(y))
        attributes.zIndex = Int(cellCount) - indexPath.item
        
        if self.rotateItems {
            if self.mirrorY {
                attributes.transform = CGAffineTransform(rotationAngle: CGFloat(2 * Float.pi - cellCurrentAngle))
            } else {
                attributes.transform = CGAffineTransform(rotationAngle: CGFloat(cellCurrentAngle))
            }
        }
        
        return attributes
        
    }
    
    // MARK: - Layout Attributes Methods
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if scrollDirection == UICollectionView.ScrollDirection.vertical {
            return self.layoutAttributesForVerticalScrollForItem(at: indexPath)
        }
        
        return self.layoutAttributesForHorozontalScrollForItem(at: indexPath)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        
        for i in 0...cellCount {
            let indexPath: IndexPath = IndexPath(row: Int(i), section: 0)
            let cellAttributes: UICollectionViewLayoutAttributes = self.layoutAttributesForItem(at: indexPath)!
            
            if (rect.intersects(cellAttributes.frame)) && (cellAttributes.alpha != 0) {
                attributes.append(self.layoutAttributesForItem(at: indexPath)!)
            }
        }
        return attributes
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        let attributes: UICollectionViewLayoutAttributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)!
        attributes.center = CGPoint(x: self.center.x + (self.collectionView?.contentOffset.x)!, y: self.center.y + (self.collectionView?.contentOffset.y)!)
        attributes.alpha = 0.2
        attributes.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        return attributes
    }
    
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        let attributes: UICollectionViewLayoutAttributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)!
        attributes.center = CGPoint(x: self.center.x + (self.collectionView?.contentOffset.x)!, y: self.center.y + (self.collectionView?.contentOffset.y)!)
        attributes.alpha = 0.2
        attributes.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        return attributes
        
    }
    
    // MARK: - Invalidate Layout
    // return YES to cause the collection view to requery the layout for geometry information
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        cache.removeAll()
    }
}
