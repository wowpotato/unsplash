//
//  ListProtocol.swift
//  unsplash
//
//  Created by myslab on 2020/06/27.
//  Copyright © 2020 mys. All rights reserved.
//

import Foundation

protocol ListProtocol {
    var page: Int { get set }
    var updateClosure: VoidClosure? { get set }
    var animateClosure: BoolClosure? { get set }
    var images: [Image] { get set }
    var query: String { get set }
    
    func fetchList()
    func nextFetchList(_ indexPath: IndexPath)
    
    mutating func updateCollectionView(_ closure: @escaping VoidClosure)
    mutating func animating(_ closure: @escaping BoolClosure)
    mutating func resetFetchList()
}

extension ListProtocol {
    mutating func updateCollectionView(_ closure: @escaping VoidClosure) {
        self.updateClosure = closure
    }
    
    mutating func animating(_ closure: @escaping BoolClosure) {
        self.animateClosure = closure
    }
    
    mutating func resetFetchList() {
        self.page = 0
        self.images.removeAll()
        self.updateClosure?()
    }
}
