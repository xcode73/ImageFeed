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
                let isSuccess = keychainWrapper.set(token, forKey: KeychainKeys.tokenKey)
                guard isSuccess else {
                    print("DEBUG:",
                          "[\(String(describing: self)).\(#function)]:",
                          "Error saving token to keychain",
                          separator: "\n")
                    return
                }
            } else {
                keychainWrapper.removeObject(forKey: KeychainKeys.tokenKey)
            }
        }
    }
    
    /// Removes token key from the keychain
    func removeTokenKey() {
        let isSuccess = keychainWrapper.removeObject(forKey: KeychainKeys.tokenKey)
        guard isSuccess else {
            print("DEBUG:",
                  "[\(String(describing: self)).\(#function)]:",
                  "Error removing token from keychain",
                  separator: "\n")
            return
        }
    }
}
