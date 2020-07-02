//
//  ListViewModel.swift
//  unsplash
//
//  Created by myslab on 2020/06/26.
//  Copyright © 2020 mys. All rights reserved.
//

import Foundation

class ListViewModel: ListProtocol {
    var component: ListComponent = ListComponent()
    let listService = ListService()
}

extension ListViewModel {
    func fetchList() {
        guard self.beforeFetch() else { return }
        listService.getImageList(self.page) { [weak self] (images) in
            guard let `self` = self else { return }
            self.afterFetch(images)
        }
    }
    
    func nextFetchList(_ indexPath: IndexPath) {
        guard self.isLoading == false else { return }
        guard indexPath.row > self.images.count / 2 else { return }
        
        self.fetchList()
    }
}
