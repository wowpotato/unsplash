//
//  Image.swift
//  unsplash
//
//  Created by myslab on 2020/06/26.
//  Copyright © 2020 mys. All rights reserved.
//

import Foundation
import UIKit

struct Image: Codable {
    let id: String?
    let createdAt : String?
    let width: CGFloat?
    let height: CGFloat?
    let urls: URLs?
    let user: User?
    
    var size: CGSize = .zero
    
    private enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width
        case height
        case urls
        case user
    }

    mutating func setSize() {
        guard let width = self.width, let height = self.height else { return }
        let screenWidth = UIScreen.main.bounds.size.width
        
        if width > screenWidth {
            let ratio = screenWidth / width
            let imageHeight = height * ratio
            self.size = CGSize(width: screenWidth, height: imageHeight)
        }
        else {
            let ratio = width / screenWidth
            let imageHeight = height * ratio
            self.size = CGSize(width: screenWidth, height: imageHeight)
        }
    }
}

struct URLs: Codable {
    let raw: String?
    let full : String?
    let regular : String?
    let small : String?
    let thumb : String?
    
    private enum CodingKeys: String, CodingKey {
        case raw
        case full
        case regular
        case small
        case thumb
    }
}

struct User: Codable {
    let name: String?
    
    private enum CodingKeys: String, CodingKey {
        case name
    }
}
