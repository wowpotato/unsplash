//
//  SearchViewModel.swift
//  unsplash
//
//  Created by myslab on 2020/06/27.
//  Copyright © 2020 mys. All rights reserved.
//

import Foundation

class SearchViewModel: ListProtocol, ServiceProtocol {
    var component: ListComponent = ListComponent()
    
    //MARK:- Private
    fileprivate var search: SearchImage?
}

extension SearchViewModel {
    func fetchList() {
        guard self.query.isValid else { return }
        guard self.beforeFetch() else { return }
        self.getSearchImageList(self.page, self.query) { [weak self] (searchImage) in
            guard let `self` = self else { return }
            guard let searchImage = searchImage, let results = searchImage.results else { return }
            self.search = searchImage
            self.afterFetch(results)
        }
    }
    
    func nextFetchList(_ indexPath: IndexPath) {
        guard self.isLoading == false else { return }
        guard let searchImage = search, let total = searchImage.total else { return }
        guard total > self.images.count else { return }
        guard indexPath.row > self.images.count / 2 else { return }
        
        self.fetchList()
    }
    
    func resetFetchList() {
        self.page = 0
        self.images.removeAll()
        self.updateClosure?()
    }
}

