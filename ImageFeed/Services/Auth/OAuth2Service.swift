//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 11.07.2024.
//

import Foundation

protocol OAuthTokenLoading {
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void)
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let networkClient: NetworkRouting
    
    private init() {
        networkClient = NetworkClient()
    }
    
    /// Fetch an OAuth token by making a network request
    /// - Parameters:
    ///   - code: code received from the OAuth provider
    ///   - completion: result of the token retrieval operation
    ///
    /// It uses the NetworkClient to perform the network request, and upon receiving a response, it decodes the token from the response data using a JSONDecoder.
    /// Finally, it calls the completion handler with the result of the token retrieval operation.
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = Endpoint.sendCode(code: code).request else {
            print("ERROR: cannot create URL")
            return
        }
        
        print("DEBUG: Fetching token with request:", request)
        
        networkClient.fetch(with: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let token = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    completion(.success(token.accessToken))
                } catch {
                    print("ERROR: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("ERROR: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
}
