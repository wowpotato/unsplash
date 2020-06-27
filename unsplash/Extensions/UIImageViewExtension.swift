//
//  UIImageViewExtension.swift
//  unsplash
//
//  Created by myslab on 2020/06/26.
//  Copyright © 2020 mys. All rights reserved.
//

import Foundation
import UIKit
import Nuke

extension UIImageView {

    //MARK:- Nuke Image 요청
    func loadImage(_ strUrl: String, transition: ImageLoadingOptions.Transition? = ImageLoadingOptions.Transition.fadeIn(duration: 0.2), completed: ImageClosure? = nil) {
        guard strUrl.isValid, let url = URL(string: strUrl) else { completed?(nil); return }
        let request: ImageRequest = ImageRequest(url: url, options: ImageRequestOptions(memoryCacheOptions: .init(isReadAllowed: true, isWriteAllowed: true)))
        let option = ImageLoadingOptions(transition: transition)
        
        Nuke.loadImage(with: request, options: option, into: self, progress: { (reponse, value1, value2) in
            
        }, completion: { [weak self] (result) in
            guard let `self` = self else { return }
            do {
                let response: ImageResponse = try result.get()
                self.backgroundColor = .clear
                completed?(response.image)
            } catch let error {
                println(error)
                completed?(nil)
            }
        })
    }
    
    
}
