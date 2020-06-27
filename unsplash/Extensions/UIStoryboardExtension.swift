//
//  UIStoryboardExtension.swift
//  unsplash
//
//  Created by myslab on 2020/06/27.
//  Copyright © 2020 mys. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard {

    public class func Storyboard<T>(storyboardName: String, identifier: T.Type) -> T?  {
        let storyboard = self.init(name: storyboardName, bundle: Bundle.main)
        if let vc = storyboard.instantiateVC(identifier) {
            return vc
        }
        else {
            return nil
        }
    }
    
    ///   Get the application's main storyboard
    /// Usage: let storyboard = UIStoryboard.mainStoryboard
    public static var mainStoryboard: UIStoryboard? {
        let bundle = Bundle.main
        guard let name = bundle.object(forInfoDictionaryKey: "UIMainStoryboardFile") as? String else {
            return nil
        }
        return UIStoryboard(name: name, bundle: bundle)
    }

    ///   Get view controller from storyboard by its class type
    /// Usage: let profileVC = storyboard!.instantiateVC(ProfileViewController) /* profileVC is of type ProfileViewController */
    /// Warning: identifier should match storyboard ID in storyboard of identifier class
    public func instantiateVC<T>(_ identifier: T.Type) -> T? {
        let storyboardID = String(describing: identifier)
        if let vc = instantiateViewController(withIdentifier: storyboardID) as? T {
            return vc
        }
        else {
            return nil
        }
    }
}
