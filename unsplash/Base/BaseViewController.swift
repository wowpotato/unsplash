//
//  BaseViewController.swift
//  unsplash
//
//  Created by myslab on 2020/06/26.
//  Copyright © 2020 mys. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class BaseViewController: UIViewController, NVActivityIndicatorViewable {

    internal var barStyle: UIStatusBarStyle = .default {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    internal var barHidden: Bool = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.barStyle
    }
        
    override var prefersStatusBarHidden: Bool {
        return self.barHidden
    }
    
    override func viewSafeAreaInsetsDidChange() {
        Common.safeAreaInsets = self.view.safeAreaInsets
    }

}
