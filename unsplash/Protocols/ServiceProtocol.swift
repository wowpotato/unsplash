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

protocol ServiceProtocol {
}

extension ServiceProtocol {
    
    func getList<T: ImageCodable>(_ identifier: T.Type, _ url: String, _ params: [String:String], completion: @escaping ([T]) -> Void) {
        let session = Session.default
        var items = params.map { "\($0)=\($1)" }
        items.sort()
        let parameters = items.reduce("") { "\($0)&\($1)" }
        print("🚀🚀🚀 URL = \(url)?\(parameters)")
        
        session.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json"]) .validate(statusCode: 200..<300).responseData { (response) in
            var results: [T] = []

            defer {
                completion(results)
            }

            do {
                guard let data = response.data else { return }
                let decoder = JSONDecoder()
                var images = try decoder.decode([T].self, from: data)
                images.modifyForEach { $1.setSize() }
                results.append(contentsOf: images)
            } catch let error {
                print(error)
            }
        }
    }
    
    func getImageList<T: ImageCodable>(_ identifier: T.Type, _ page: Int, completion: @escaping ([T]) -> Void) {
        let url = "\(Service.url)\(Service.photos)"
        let params = ["page":page.toString, "per_page":"30", "order_by":"popular", "client_id":Service.clientID, "client_secret":Service.clientSecret]
       
        self.getList(identifier, url, params, completion: completion)
    }
    
    func getSearchImageList(_ page: Int, _ query: String, completion: @escaping SearchResult) {
        let session = Session.default
        let url = "\(Service.url)\(Service.searchPhotos)"
        let params = ["query":query, "page":page.toString, "per_page":"30", "order_by":"relevant", "client_id":Service.clientID, "client_secret":Service.clientSecret]
        var items = params.map { "\($0)=\($1)" }
        items.sort()
        let parameters = items.reduce("") { "\($0)&\($1)" }
        print("🚀🚀🚀 URL = \(url)?\(parameters)")
        
        session.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json"]) .validate(statusCode: 200..<300).responseData { (response) in
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
