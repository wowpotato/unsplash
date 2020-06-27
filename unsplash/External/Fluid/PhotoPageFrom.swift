//
//  PhotoPageFrom.swift
//  unsplash
//
//  Created by myslab on 2020/06/26.
//  Copyright © 2020 mys. All rights reserved.
//

import Foundation
import UIKit

class PhotoPageFrom {
    var collectionView: UICollectionView!
    var targetView: UIView!
    var indexPath: IndexPath!
    var direction: UICollectionView.ScrollPosition = .centeredHorizontally
     
    convenience init(_ collectionView: UICollectionView, _ targetView: UIView, _ indexPath: IndexPath) {
        self.init()
        self.collectionView = collectionView
        self.targetView = targetView
        self.indexPath = indexPath
    }
    
    convenience init(_ collectionView: UICollectionView, _ targetView: UIView, _ index: Int) {
        self.init()
        self.collectionView = collectionView
        self.targetView = targetView
        self.indexPath = IndexPath(row: index, section: 0)
    }
    
    func scrollToItem(_ indexPath: IndexPath) {
        self.indexPath = indexPath
        self.collectionView.scrollToItem(at: indexPath, at: direction, animated: false)
    }
}

extension PhotoPageFrom: ZoomAnimatorDelegate {
    func transitionWillStartWith(zoomAnimator: ZoomAnimator) {
        
    }
    
    func transitionDidEndWith(zoomAnimator: ZoomAnimator) {
        guard let view = self.targetView else { return }
        guard let indexPath = self.indexPath else { return }
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        let cellFrame = collectionView.convert(cell.frame, to: view)
        
        if cellFrame.minY < collectionView.contentInset.top {
            collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
        }
        else if cellFrame.maxY > view.frame.height - collectionView.contentInset.bottom {
            collectionView.scrollToItem(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    func referenceImageView(for zoomAnimator: ZoomAnimator) -> UIImageView? {
        guard let indexPath = self.indexPath else { return nil }
        
        //Get a guarded reference to the cell's UIImageView
        let referenceImageView = getImageViewFromCollectionViewCell(for: indexPath)
        return referenceImageView
    }
    
    func referenceImageViewFrameInTransitioningView(for zoomAnimator: ZoomAnimator) -> CGRect? {
        guard let view = self.targetView else { return .zero }
        guard let indexPath = self.indexPath else { return .zero }
        
        view.layoutIfNeeded()
        collectionView.layoutIfNeeded()
        
        //Get a guarded reference to the cell's frame
        let unconvertedFrame: CGRect = getFrameFromCollectionViewCell(for: indexPath)
        let cellFrame = collectionView.convert(unconvertedFrame, to: view)
        
        if cellFrame.minY < collectionView.contentInset.top {
            return CGRect(x: cellFrame.minX, y: collectionView.contentInset.top, width: cellFrame.width, height: cellFrame.height - (collectionView.contentInset.top - cellFrame.minY))
        }
        
        return cellFrame
    }
    
    func getImageViewFromCollectionViewCell(for selectedIndexPath: IndexPath) -> UIImageView? {
        guard let indexPath = self.indexPath else { return nil }
        
        //Get the array of visible cells in the collectionView
        let visibleCells = collectionView.indexPathsForVisibleItems
        
        //If the current indexPath is not visible in the collectionView,
        //scroll the collectionView to the cell to prevent it from returning a nil value
        if !visibleCells.contains(indexPath) {
           
            //Scroll the collectionView to the current selectedIndexPath which is offscreen
            collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
            
            //Reload the items at the newly visible indexPaths
            collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
            collectionView.layoutIfNeeded()
            
            //Guard against nil values
            guard let guardedCell = collectionView.cellForItem(at: indexPath) else {
                //Return a default UIImageView
                return UIImageView(frame: CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0))
            }
            //The PhotoCollectionViewCell was found in the collectionView, return the image
            guard let imageView = self.findImageView(guardedCell) else { return nil }
            return imageView
        }
        else {
            
            //Guard against nil return values
            guard let guardedCell = collectionView.cellForItem(at: indexPath) else {
                //Return a default UIImageView
                return UIImageView(frame: CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0))
            }
            //The PhotoCollectionViewCell was found in the collectionView, return the image
            guard let imageView = self.findImageView(guardedCell) else { return nil }
            return imageView
        }
    }
    
    func findImageView(_ superView: UIView) -> UIImageView? {
        if let imageView = superView.viewWithTag(99999) as? UIImageView {
            return imageView
        }
        
        if let imageView = superView as? UIImageView, imageView.restorationIdentifier == "fluid" {
            return imageView
        }
        else {
            for child in superView.subviews {
                if let value = self.findImageView(child) {
                    return value
                }
            }
        }
        assertionFailure("You have to set as ImageView Tag = 99999 or fluid restorationIdentifier" )
        return nil
    }
    
    //This function prevents the collectionView from accessing a deallocated cell. In the
    //event that the cell for the selectedIndexPath is nil, a default CGRect is returned in its place
    func getFrameFromCollectionViewCell(for selectedIndexPath: IndexPath) -> CGRect {
        guard let indexPath = self.indexPath else { return .zero }
        
        //Get the currently visible cells from the collectionView
        let visibleCells = collectionView.indexPathsForVisibleItems
        
        //If the current indexPath is not visible in the collectionView,
        //scroll the collectionView to the cell to prevent it from returning a nil value
        if !visibleCells.contains(selectedIndexPath) {
            
            //Scroll the collectionView to the cell that is currently offscreen
            collectionView.scrollToItem(at: selectedIndexPath, at: .centeredVertically, animated: false)
            
            //Reload the items at the newly visible indexPaths
            collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
            collectionView.layoutIfNeeded()
            
            //Prevent the collectionView from returning a nil value
            guard let guardedCell = collectionView.cellForItem(at: indexPath) else {
                return CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0)
            }
            
            return guardedCell.frame
        }
        //Otherwise the cell should be visible
        else {
            //Prevent the collectionView from returning a nil value
            guard let guardedCell = collectionView.cellForItem(at: indexPath)  else {
                return CGRect(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY, width: 100.0, height: 100.0)
            }
            //The cell was found successfully
            
            return guardedCell.frame
        }
    }
}
