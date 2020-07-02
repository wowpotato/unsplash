//
//  ListProtocol.swift
//  unsplash
//
//  Created by myslab on 2020/06/27.
//  Copyright © 2020 mys. All rights reserved.
//

import Foundation

struct ListComponent {
    var page: Int = 0
    var isLoading: Bool = false
    var images: [Image] = []
    var query: String = ""
    
    var updateClosure: VoidClosure?
    var animateClosure: BoolClosure?
}

protocol ListProtocol: class {
    var component : ListComponent { get set }
    
    func fetchList()
    func nextFetchList(_ indexPath: IndexPath)
    func resetFetchList()
    func beforeFetch() ->  Bool
    func afterFetch(_ images: [Image])
}

extension ListProtocol  {
    var page: Int {
        get { return component.page }
        set {
            component.page = newValue
            if newValue == 1 {
                self.animateClosure?(true)
            }
        }
    }
    var isLoading: Bool {
        get { return component.isLoading }
        set { component.isLoading = newValue }
    }
    
    var images: [Image] {
        get { return component.images }
        set { component.images = newValue }
    }
    
    var query: String {
        get { return component.query }
        set { component.query = newValue }
    }
    
    var updateClosure: VoidClosure? {
        get { return component.updateClosure }
        set { component.updateClosure = newValue }
    }
    
    var animateClosure: BoolClosure? {
        get { return component.animateClosure }
        set { component.animateClosure = newValue }
    }

    func resetFetchList() { }
    
    func beforeFetch() ->  Bool {
        guard self.isLoading == false else { return false }
        self.isLoading = true
        self.page += 1
        return true
    }
    
    func afterFetch(_ images: [Image]) {
        self.isLoading = false
        self.images.append(contentsOf: images)
        self.updateClosure?()
        self.animateClosure?(false)
    }
}

