//
//  Define.swift
//  unsplash
//
//  Created by myslab on 2020/06/26.
//  Copyright © 2020 mys. All rights reserved.
//

import Foundation
import UIKit

typealias VoidClosure                   = () -> Void
typealias BoolClosure                   = (_ value: Bool) -> Void
typealias IntegerClosure                = (_ value: Int) -> Void
typealias AnyClosure                    = (_ value: Any?) -> Void
typealias ImageClosure                  = (_ value: UIImage?) -> Void
typealias ListResult                    = ([Image]) -> Void
typealias SearchResult                  = (SearchImage?) -> Void

