//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 09.07.2024.
//

import Foundation

final class OAuth2TokenStorage {
    
    private let userDefaults = UserDefaults.standard
    
    var token: String? {
        get {
            userDefaults.string(forKey: "token")
        }
        set {
            userDefaults.set(newValue, forKey: "token")
        }
    }
}
