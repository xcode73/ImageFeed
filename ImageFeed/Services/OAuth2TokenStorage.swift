//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 09.07.2024.
//

import Foundation

final class OAuth2TokenStorage {
    private let storage = UserDefaults.standard
    private let key = "bearer_token"
    
    var token: String? {
        get {
            return storage.string(forKey: key)
        }
        set {
            storage.set(newValue, forKey: key)
        }
    }
}
