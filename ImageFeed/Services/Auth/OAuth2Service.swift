//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 11.07.2024.
//

import Foundation

/// Fetch an OAuth token by making a network request
final class OAuth2Service {
    static let shared = OAuth2Service(networkClient: NetworkClient())
    
    private let tokenStorage = OAuth2TokenStorage()
    private let networkClient: NetworkRouting
    
    private enum JSONError: Error {
        case decodingError
    }
    
    private(set) var authToken: String? {
        get {
            return tokenStorage.token
        }
        set {
            tokenStorage.token = newValue
        }
    }

    private init(networkClient: NetworkRouting) {
        self.networkClient = networkClient
    }
    
    /// Fetch an OAuth token by making a network request
    /// - Parameters:
    ///   - code: code received from the OAuth provider
    ///   - completion: Result of the token retrieval operation
    ///
    /// It uses the NetworkClient to perform the network request, and upon receiving a response, it decodes the token from the response data using a JSONDecoder.
    /// Finally, it calls the completion handler with the result of the token retrieval operation.
    /// network client
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = Endpoint.sendCode(code: code).request else {
            fatalError("cannot create URL")
        }
        
        print("DEBUG:", "Auth request: \(request)")
        
        networkClient.fetch(request: request) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let oAuthToken = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    print("DEBUG:", "OAuth token: \(oAuthToken) decoded")
                    let accessToken = oAuthToken.accessToken
                    self.authToken = accessToken
                    print("DEBUG:", "OAuth token: \(accessToken) stored in tokenStorage")
                    completion(.success(oAuthToken.accessToken))
                } catch {
                    print("ERROR: JSON decoding error \(error.localizedDescription)")
                    completion(.failure(JSONError.decodingError))
                }
            case .failure(let error):
                completion(.failure(error))
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }
}
