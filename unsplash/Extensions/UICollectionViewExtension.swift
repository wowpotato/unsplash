//
//  UICollectionViewExtension.swift
//  unsplash
//
//  Created by myslab on 2020/06/26.
//  Copyright © 2020 mys. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    private struct AssociatedKeys {
        static var registerCellName: UInt8 = 0
        static var registerHeaderName: UInt8 = 0
        static var registerFooterName: UInt8 = 0
    }
    
    public var registerCellNames: [String] {
        get {
            if let result: [String] = objc_getAssociatedObject(self, &AssociatedKeys.registerCellName) as? [String] {
                return result
            }
            let result: [String] = [String]()
            objc_setAssociatedObject(self, &AssociatedKeys.registerCellName, result, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return result
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.registerCellName, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public var registerHeaderNames: [String] {
        get {
            if let result:[String] = objc_getAssociatedObject(self, &AssociatedKeys.registerHeaderName) as? [String] {
                return result
            }
            let result: [String] = [String]()
            objc_setAssociatedObject(self, &AssociatedKeys.registerHeaderName, result, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return result
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.registerHeaderName, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    public var registerFooterNames: [String] {
        get {
            if let result: [String] = objc_getAssociatedObject(self, &AssociatedKeys.registerFooterName) as? [String] {
                return result
            }
            let result: [String] = [String]()
            objc_setAssociatedObject(self, &AssociatedKeys.registerFooterName, result, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return result
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.registerFooterName, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private func isXibFileExists(_ className: String) -> Bool {
        if let path: String = Bundle.main.path(forResource: className, ofType: "nib") {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        return false
    }
    
    public func registerDefaultCell() {
        register(UICollectionViewCell.self)
        registerHeader(UICollectionReusableView.self)
        registerFooter(UICollectionReusableView.self)
    }
    
    public func register(_ Classs: UICollectionViewCell.Type...) {
        for Class: UICollectionViewCell.Type in Classs {
            guard registerCellNames.contains(Class.className) == false else { continue }
            
            registerCellNames.append(Class.className)
            if isXibFileExists(Class.className) {
                registerNibCell(Class)
            }
            else {
                register(Class, forCellWithReuseIdentifier: Class.className)
            }
        }
    }
    
    public func register(Class: UICollectionViewCell.Type, withReuseIdentifier: String) {
        guard registerCellNames.contains(withReuseIdentifier) == false else { return }
        
        registerCellNames.append(withReuseIdentifier)
        if isXibFileExists(Class.className) {
            registerNibCell(Class:Class, withReuseIdentifier: withReuseIdentifier)
        }
        else {
            register(Class, forCellWithReuseIdentifier: withReuseIdentifier)
        }
    }
    
    public func registerHeader(_ Classs: UICollectionReusableView.Type...) {
        for Class: UICollectionReusableView.Type in Classs {
            guard registerHeaderNames.contains(Class.className) == false else { continue }
            
            registerHeaderNames.append(Class.className)
            if isXibFileExists(Class.className) {
                registerNibCellHeader(Class)
            }
            else {
                register(Class, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Class.className)
            }
        }
    }
    
    public func registerHeader(Class: UICollectionReusableView.Type, withReuseIdentifier: String) {
        guard registerHeaderNames.contains(withReuseIdentifier) == false else { return }
        
        registerHeaderNames.append(withReuseIdentifier)
        if isXibFileExists(Class.className) {
            registerNibCellHeader(Class:Class, withReuseIdentifier: withReuseIdentifier)
        }
        else {
            register(Class, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: withReuseIdentifier)
        }
    }
    
    
    public func registerFooter(_ Classs: UICollectionReusableView.Type...) {
        for Class: UICollectionReusableView.Type in Classs {
            guard registerFooterNames.contains(Class.className) == false else { continue }
            
            registerFooterNames.append(Class.className)
            if isXibFileExists(Class.className) {
                registerNibCellFooter(Class)
                return
            }
            else {
                register(Class, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: Class.className)
            }
        }
    }
    
    public func registerFooter(Class: UICollectionReusableView.Type, withReuseIdentifier: String) {
        guard registerFooterNames.contains(Class.className) == false else { return }
        
        registerFooterNames.append(Class.className)
        if isXibFileExists(Class.className) {
            registerNibCellFooter(Class:Class, withReuseIdentifier: withReuseIdentifier)
            return
        }
        else {
            register(Class, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: withReuseIdentifier)
        }
    }
    
    public func registerNibCell(_ Classs: UICollectionViewCell.Type...) {
        Classs.forEach { (Class: UICollectionViewCell.Type) in
            register(UINib(nibName: Class.className, bundle: nil), forCellWithReuseIdentifier: Class.className)
        }
    }
    
    public func registerNibCell(Class: UICollectionViewCell.Type, withReuseIdentifier: String) {
        register(UINib(nibName: Class.className, bundle: nil), forCellWithReuseIdentifier: withReuseIdentifier)
    }
    
    
    public func registerNibCellHeader(_ Classs: UICollectionReusableView.Type...) {
        Classs.forEach { (Class: UICollectionReusableView.Type) in
            register(UINib(nibName: Class.className, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Class.className)
        }
    }
    
    public func registerNibCellHeader(Class: UICollectionReusableView.Type, withReuseIdentifier: String) {
        register(UINib(nibName: Class.className, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: withReuseIdentifier)
    }
    
    
    public func registerNibCellFooter(_ Classs: UICollectionReusableView.Type...) {
        Classs.forEach { (Class: UICollectionReusableView.Type) in
            register(UINib(nibName: Class.className, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: Class.className)
        }
    }
    
    public func registerNibCellFooter(Class: UICollectionReusableView.Type, withReuseIdentifier: String) {
        register(UINib(nibName: Class.className, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: withReuseIdentifier)
    }
    
    public func registerCustomKindReusableView(_ Class: UICollectionReusableView.Type, _ Kind: String, _ identifier: String) {
        register(Class, forSupplementaryViewOfKind: Kind, withReuseIdentifier: identifier)
    }
    
    public func dequeueReusableCell<T:UICollectionViewCell>(_ Class: T.Type, for indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withReuseIdentifier: Class.className, for: indexPath) as! T
        cell.indexPath = indexPath
        return cell
    }
    
    public func dequeueReusableCell<T:UICollectionViewCell>(_ Class: T.Type, for indexPath: IndexPath, withReuseIdentifier: String) -> T {
        let cell = dequeueReusableCell(withReuseIdentifier: withReuseIdentifier, for: indexPath) as! T
        cell.indexPath = indexPath
        return cell
    }
    
    public func dequeueReusableHeader<T:UICollectionReusableView>(_ Class: T.Type, for indexPath: IndexPath) -> T {
        let view = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Class.className, for: indexPath) as! T
        view.indexPath = indexPath
        return view
    }
    
    public func dequeueReusableHeader<T:UICollectionReusableView>(_ Class: T.Type, for indexPath: IndexPath, withReuseIdentifier: String) -> T {
        let view = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: withReuseIdentifier, for: indexPath) as! T
        view.indexPath = indexPath
        return view
    }
    
    public func dequeueReusableFooter<T:UICollectionReusableView>(_ Class: T.Type, for indexPath: IndexPath) -> T {
        let view = dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: Class.className, for: indexPath) as! T
        view.indexPath = indexPath
        return view
    }
    
    public func dequeueDefaultSupplementaryView(ofKind kind: String, for indexPath: IndexPath) -> UICollectionReusableView {
        let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
        view.indexPath = indexPath
        return view
    }
    
    public func realodSectionWithoutAnimation(_ indexPath: IndexPath) {
        self.realodSectionWithoutAnimation(indexPath.section)
    }
    
    public func realodSectionWithoutAnimation(_ section: Int) {
        UIView.setAnimationsEnabled(false)
        self.performBatchUpdates({
            self.reloadSections([section])
        }, completion: { (finished) in
            UIView.setAnimationsEnabled(true)
        })
    }
}


extension UICollectionReusableView {
    private struct AssociatedKeys {
        static var indexPath: UInt8 = 0
    }
    public var indexPath: IndexPath {
        get {
            if let indexPath: IndexPath = objc_getAssociatedObject(self, &AssociatedKeys.indexPath) as? IndexPath {
                return indexPath
            }
            return IndexPath(row: 0, section: 0)
            
        }
        set { objc_setAssociatedObject(self, &AssociatedKeys.indexPath, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
    
}


