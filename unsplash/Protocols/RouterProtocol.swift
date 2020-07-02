//
//  Router.swift
//  unsplash
//
//  Created by myslab on 2020/06/26.
//  Copyright © 2020 mys. All rights reserved.
//

import Foundation
import UIKit

protocol RouterProtocol: BaseViewController {
    static var storyboardName: String { get }
}

extension RouterProtocol {
    
    //MARK:- getViewController
    static func getViewController() -> Self {
        guard self.storyboardName.isValid else { return self.init() }
        let storyboard = UIStoryboard(name: self.storyboardName, bundle: Bundle.main)
        let identifier = String(describing: self)
        guard let vc = storyboard.instantiateViewController(withIdentifier: identifier) as? Self else { return self.init() }
        return vc
    }

    //MARK:- pushViewController
    @discardableResult
    static func pushViewController(_ navigationController: UINavigationController?, _ animated: Bool = true) -> Self {
        print("✈️ pushViewController : \(String(describing: self))")
        let vc = getViewController()
        navigationController?.pushViewController(vc, animated: animated)
        return vc
    }
    
    //MARK:- transparent presentViewController
    @discardableResult
    static func transparentPresentViewController(_ navigationController: UINavigationController?, _ animated: Bool = true) -> Self {
        let vc = getViewController()
        vc.modalPresentationStyle = .overFullScreen
        navigationController?.definesPresentationContext = false
        navigationController?.visibleViewController?.present(vc, animated: animated, completion: nil)
        return vc
    }
    
    
    
}



