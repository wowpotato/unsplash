//
//  ListViewModel.swift
//  unsplash
//
//  Created by myslab on 2020/06/26.
//  Copyright © 2020 mys. All rights reserved.
//

import Foundation

class ListViewModel: ListProtocol {
    //MARK:- Networking
    var page: Int = 0
    var isLoading: Bool = false
    let listService = ListService()
    
    //MARK:- Protocol
    var query: String = ""
    var images: [Image] = []
    var updateClosure: VoidClosure?
    var animateClosure: BoolClosure?
}

extension ListViewModel {
    func fetchList() {
        guard self.isLoading == false else { return }
        self.isLoading = true
        
        self.page += 1
        if self.page == 1 {
            self.animateClosure?(true)
        }
        listService.getImageList(self.page) { [weak self] (images) in
            guard let `self` = self else { return }
            self.isLoading = false
            self.images.append(contentsOf: images)
            self.updateClosure?()
            self.animateClosure?(false)
        }
    }
    
    func nextFetchList(_ indexPath: IndexPath) {
        guard self.isLoading == false else { return }
        guard indexPath.row > self.images.count / 2 else { return }
        
        self.fetchList()
    }
}
