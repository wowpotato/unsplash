//
//  Log.swift
//  unsplash
//
//  Created by myslab on 2020/06/26.
//  Copyright © 2020 mys. All rights reserved.
//

import Foundation

public func println<T>(_ object: T, _ file: String = #file, _ function: String = #function, _ line: Int = #line){
    #if DEBUG
    printLog(object, true, file, function, line)
    #else
    #endif
}

private func printLog<T>(_ object: T, _ print: Bool, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    
    var prefix = ""
    if print {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss:SSS"
        let dateString: String = dateFormatter.string(from: Date())
        let className: String = file.lastPathComponent
        prefix = "\(dateString) \(className) \(function) [\(line)] : "
    }
    
    Swift.print("\(prefix)\(object)")
    
}
