//
//  ListService.swift
//  unsplash
//
//  Created by myslab on 2020/06/26.
//  Copyright © 2020 mys. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ListService {
    
    let session = Session.default
    
    func getImageList(_ page: Int, completion: @escaping ListResult) {
        let url = "\(Service.url)\(Service.photos)"
        let params = ["page":page.toString, "per_page":"30", "order_by":"popular", "client_id":Service.clientID, "client_secret":Service.clientSecret]
        var items = params.map { "\($0)=\($1)" }
        items.sort()
        let parameters = items.reduce("") { "\($0)&\($1)" }
        print("🚀🚀🚀 URL = \(url)?\(parameters)")
        
        self.session.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json"]) .validate(statusCode: 200..<300).responseData { (response) in
            var results: [Image] = []

            defer {
                completion(results)
            }

            do {
                guard let data = response.data else { return }
                let decoder = JSONDecoder()
                var images = try decoder.decode([Image].self, from: data)
                images.modifyForEach { $1.setSize() }
                results.append(contentsOf: images)
            } catch let error {
                print(error)
            }
        }
    }
    
    func getSearchImageList(_ page: Int, _ query: String, completion: @escaping SearchResult) {
        let url = "\(Service.url)\(Service.searchPhotos)"
        let params = ["query":query, "page":page.toString, "per_page":"30", "order_by":"relevant", "client_id":Service.clientID, "client_secret":Service.clientSecret]
        var items = params.map { "\($0)=\($1)" }
        items.sort()
        let parameters = items.reduce("") { "\($0)&\($1)" }
        print("🚀🚀🚀 URL = \(url)?\(parameters)")
        
        self.session.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json"]) .validate(statusCode: 200..<300).responseData { (response) in
            var searchImage: SearchImage?

            defer {
                completion(searchImage)
            }

            do {
                guard let data = response.data else { return }
                let decoder = JSONDecoder()
                var search = try decoder.decode(SearchImage.self, from: data)
                search.results?.modifyForEach { $1.setSize() }
                searchImage = search
            } catch let error {
                print(error)
            }
        }
    }
   
}
