//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 09.07.2024.
//

import SwiftKeychainWrapper

private struct KeychainKeys {
     static let tokenKey: String = "token"
}

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    
    private init() {}
    
    private var keychainWrapper = KeychainWrapper.standard
    
    var token: String? {
        get {
            keychainWrapper.string(forKey: KeychainKeys.tokenKey)
        }
        set {
            if let token = newValue {
                let isSuccess = KeychainWrapper.standard.set(token, forKey: KeychainKeys.tokenKey)
                guard isSuccess else {
                    return
                }
            } else {
                keychainWrapper.removeObject(forKey: KeychainKeys.tokenKey)
            }
        }
    }
    
    /// Removes all keys from the keychain
    func removeAllKeys() {
        KeychainWrapper.standard.removeAllKeys()
    }
}
