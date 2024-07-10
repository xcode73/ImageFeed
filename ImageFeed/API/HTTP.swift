//
//  HTTP.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 10.07.2024.
//

import Foundation

enum HTTP {
    
    enum Method: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum Headers {
        
        enum Key: String {
            case contentType = "Content-Type"
        }
        
        enum Value: String {
            case applicationJson = "application/json"
        }
    }
}
