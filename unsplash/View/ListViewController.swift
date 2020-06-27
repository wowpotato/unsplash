//
//  ViewController.swift
//  unsplash
//
//  Created by myslab on 2020/06/26.
//  Copyright © 2020 mys. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ListViewController: BaseViewController, RouterProtocol, NVActivityIndicatorViewable {
    static var storyboardName: String = Storyboard.Main.rawValue
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: ListProtocol
    
    required init?(coder: NSCoder) {
        self.viewModel = ListViewModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.searchBar.backgroundImage = UIImage()
        
        self.collectionView.registerNibCell(ListCell.self)
        
        self.viewModel.fetchList()
        self.viewModel.updateCollectionView { [weak self] () in
            guard let `self` = self else { return }
            self.searchBar.resignFirstResponder()
            self.collectionView.reloadData()
        }
        
        self.viewModel.animating{ [weak self] (show) in
            guard let `self` = self else { return }
            if show {
                self.startAnimating(type: .ballGridPulse)
            }
            else {
                self.stopAnimating()
            }
        }
    }
}

//MARK:- UICollectionView
extension ListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(ListCell.self, for: indexPath)
        let image = self.viewModel.images[indexPath.row]
        cell.configure(image)
        return cell
    }
}

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        PhotoPageViewController.pushVC(self.view, indexPath.row, self.viewModel.images, collectionView, nvc: self.navigationController)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.viewModel.nextFetchList(indexPath)
    }
}

extension ListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let image = self.viewModel.images[indexPath.row]
        return image.size
    }
}

//MARK:- UISearchBar
extension ListViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        SearchViewController.pushViewController(self.navigationController, false)
        return false
    }
}
