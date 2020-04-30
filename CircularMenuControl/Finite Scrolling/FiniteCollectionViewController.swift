//
//  FiniteCollectionViewController.swift
//  CircularMenuDemo
//
//  Created by IOS on 16/04/20.
//  Copyright © 2020 IOS. All rights reserved.
//

import UIKit

let ITEM_WIDTH = 130
let ITEM_HEIGHT = 190

public class FiniteCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var circularCollectionView: UICollectionView!
    @IBOutlet weak var selectedCellLabel: UILabel!
    @IBOutlet weak var constraintCollectionViewTop: NSLayoutConstraint!
    
    // MARK: - Variables
    // Global array: circularMenuOptions
    // Local array: arrMenuOptions
    var arrMenuOptions = [String]()
    public var circularMenuOptions = [String]()

    var count: Int!
    var scrollDirection: String!
    var initialScrollDone: Bool = false
    
    // MARK: - View Lifecycle Methods
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Load menu options
        self.arrMenuOptions = circularMenuOptions
        count = arrMenuOptions.count
        
        if self.count < 6 {
            switch count {
            case 2:
                self.arrMenuOptions.insert("", at: 0)
                self.arrMenuOptions.insert("", at: 1)
                self.arrMenuOptions.insert("", at: 2)
                self.arrMenuOptions.append("")
                
            case 3:
                self.arrMenuOptions.insert("", at: 0)
                self.arrMenuOptions.insert("", at: 1)
                self.arrMenuOptions.append("")
                
            case 4:
                self.arrMenuOptions.insert("", at: 0)
                self.arrMenuOptions.append("")
                
            case 5:
                self.arrMenuOptions.insert("", at: 0)
                self.arrMenuOptions.append("")
                
            default:
                self.arrMenuOptions.append("")
                
            }
        } else {
            self.arrMenuOptions.append("")
            
        }
                
        //------- Set background image to the CollectionView ----------//

        let bgImage = UIImageView()
        
        let bundle = Bundle(for: type(of: self))
        if let image = UIImage(named: "semi-circle", in: bundle, compatibleWith: nil) {
            bgImage.image = image
        } else {
            bgImage.image = UIImage(named: "semi-circle")
        }
        
        bgImage.contentMode = .scaleAspectFit
        self.circularCollectionView?.backgroundView = bgImage
        
        //------------//
        
        // Set Layout of CollectionView
        self.setCircularLayout()
        
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // Make UI compatible for all devices
        if UIDevice().userInterfaceIdiom == .phone {
               switch UIScreen.main.nativeBounds.height {
               case 1136:
                   print("IPHONE 5,5S,5C")
               case 1334:
                //"IPHONE 6,7,8 IPHONE 6S,7S,8S "
                constraintCollectionViewTop.constant = 80
               case 1920, 2208:
                //"IPHONE 6PLUS, 6SPLUS, 7PLUS, 8PLUS"
                constraintCollectionViewTop.constant = 120
               case 2436:
                //"IPHONE X, IPHONE XS, IPHONE 11 PRO"
                constraintCollectionViewTop.constant = 150
               case 2688:
                //"IPHONE XS MAX, IPHONE 11 PRO MAX"
                constraintCollectionViewTop.constant = 180
               case 1792:
                //"IPHONE XR, IPHONE 11"
                constraintCollectionViewTop.constant = 180
               default:
                   print("UNDETERMINED")
               }
           }
        
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Insert menu options in view
        self.insertItemsInView()
    }
    
    // MARK: - Custom Methods
    func insertItemsInView() {
        circularCollectionView.performBatchUpdates({
            let insertIndexPaths = Array(0...count-1).map { IndexPath(item: $0, section: 0) }
            circularCollectionView.insertItems(at: insertIndexPaths)
        }) { (finished) in
            self.circularCollectionView.reloadData()

        }
    }
    
    // Prepare Layout
    func setCircularLayout() {
        let circularLayout: FiniteCollectionViewLayout = FiniteCollectionViewLayout()
        circularLayout.initWithCentre(center: CGPoint(x: 10, y: 280),
                                      radius: 200,
                                      itemSize: CGSize(width: ITEM_WIDTH, height: ITEM_HEIGHT),
                                      angularSpacing: -100)
        circularLayout.setStartAngle(startAngle: Float.pi/2, endAngle: 3*Float.pi/2)
        circularLayout.mirrorX = false
        circularLayout.mirrorY = false
        circularLayout.rotateItems = true
        circularLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        self.circularCollectionView.collectionViewLayout = circularLayout
        
    }
    
    // MARK: - CollectionView Data Source & Delegate Methods
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count+4 // +4 is due to adding extra elements; (3 in the first) and (1 in the last)
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var index = indexPath.item
        if(index > arrMenuOptions.count - 1) {
            index -= arrMenuOptions.count
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FiniteCollectionViewCell
        
        cell.titleLabel.text = arrMenuOptions[index]
        cell.titleLabel.textColor = .white
        cell.titleLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)
        cell.titleLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi/2)
        cell.titleLabel.frame = CGRect(x: cell.titleLabel.frame.origin.x, y: cell.titleLabel.frame.origin.y, width: cell.titleLabel.frame.width, height: cell.titleLabel.frame.height)
        
        if index == 3 { // center of visible cells(currently 7 cells are visible)
            if !initialScrollDone {
                self.selectedCellLabel.text = "\(self.arrMenuOptions[3])"
            }
        }
        
        return cell
    }
    
    // MARK: - Scrollview Delegate Methods
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        initialScrollDone = true
        
        let arrBlankItems = ["", "", ""]
        self.arrMenuOptions = circularMenuOptions
        self.arrMenuOptions.insert(contentsOf: arrBlankItems, at: 0)
        self.arrMenuOptions.append("")
    
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.getSelectedOption()
        
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.getSelectedOption()
        }
    }
    
    // Get the selected option where user ends scrolling
    func getSelectedOption() {
        
        self.circularCollectionView.decelerationRate = UIScrollView.DecelerationRate.fast

        var visibleRect = CGRect()
        
        visibleRect.origin = circularCollectionView.contentOffset
        visibleRect.size = circularCollectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY-30)
        
        guard let indexPath = circularCollectionView.indexPathForItem(at: visiblePoint) else { return }
        print("Selected Item:\(arrMenuOptions[indexPath.item+1])")
                
        let selectedItem = indexPath.item
        let nextindexpath = IndexPath(item: selectedItem+1, section: 0)
        
         //------- SCROLL to Row Center ----------//
          let currentItem = nextindexpath.item - 3
         
          let diff = 1.5
          let cellYCenter = Double(ITEM_HEIGHT/4) - diff
          let yAxis:CGFloat = CGFloat(cellYCenter * Double(currentItem))
         
          circularCollectionView.reloadData()
          circularCollectionView.layoutSubviews()

          circularCollectionView.scrollRectToVisible(CGRect(x: visibleRect.origin.x, y: yAxis, width: circularCollectionView.frame.size.width, height: circularCollectionView.frame.size.height), animated: true)
          //---------------//
         
        // Update Selected Option
        DispatchQueue.main.async {
            self.selectedCellLabel.text = "\(self.arrMenuOptions[indexPath.item+1])"
        }
        
    }
}
