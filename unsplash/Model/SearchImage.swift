//
//  SearchImage.swift
//  unsplash
//
//  Created by myslab on 2020/06/27.
//  Copyright © 2020 mys. All rights reserved.
//

import Foundation

struct SearchImage: Codable {
    
    let total: Int?
    let totalPages: Int?
    var results: [Image]?
    
    private enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}
