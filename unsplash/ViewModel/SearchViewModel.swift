//
//  SearchViewModel.swift
//  unsplash
//
//  Created by myslab on 2020/06/27.
//  Copyright © 2020 mys. All rights reserved.
//

import Foundation

class SearchViewModel: ListProtocol {
    //MARK:- Networking
    var page: Int = 0
    var isLoading: Bool = false
    let listService = ListService()
    
    //MARK:- Protocol
    var query: String = ""
    var images: [Image] = []
    var updateClosure: VoidClosure?
    var animateClosure: BoolClosure?
    
    //MARK:- Private
    fileprivate var search: SearchImage?
}

extension SearchViewModel {
    func fetchList() {
        guard self.isLoading == false else { return }
        guard self.query.isValid else { return }
        self.isLoading = true
        
        self.page += 1
        if self.page == 1 {
            self.animateClosure?(true)
        }
        listService.getSearchImageList(self.page, self.query) { [weak self] (searchImage) in
            guard let `self` = self else { return }
            guard let searchImage = searchImage, let results = searchImage.results else { return }
            self.search = searchImage
            self.isLoading = false
            self.images.append(contentsOf: results)
            self.updateClosure?()
            self.animateClosure?(false)
        }
    }
    
    func nextFetchList(_ indexPath: IndexPath) {
        guard self.isLoading == false else { return }
        guard let searchImage = search, let total = searchImage.total else { return }
        guard total > self.images.count else { return }
        guard indexPath.row > self.images.count / 2 else { return }
        
        self.fetchList()
    }
}

