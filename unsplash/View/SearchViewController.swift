//
//  SearchViewController.swift
//  unsplash
//
//  Created by myslab on 2020/06/27.
//  Copyright © 2020 mys. All rights reserved.
//

import UIKit

class SearchViewController: ListViewController {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.viewModel = SearchViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.searchBar.becomeFirstResponder()
        self.searchBar.setShowsCancelButton(true, animated: true)
    }
}

extension SearchViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
}

//MARK:- UISearchBar
extension SearchViewController {
    override func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, query.isValid else { return }
        self.viewModel.resetFetchList()
        self.viewModel.query = query
        self.viewModel.fetchList()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.navigationController?.popViewController(animated: false)
    }
}
