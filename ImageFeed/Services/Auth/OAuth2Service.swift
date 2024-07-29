//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 11.07.2024.
//

import Foundation

enum AuthServiceError: Error {
    case invalidRequest
}

/// Fetch an OAuth token by making a network request
final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let tokenStorage = OAuth2TokenStorage()
    private let urlSession = URLSession.shared
    
    private var lastCode: String?
    private var task: URLSessionTask?
    
    private(set) var authToken: String? {
        get {
            return tokenStorage.token
        }
        set {
            tokenStorage.token = newValue
        }
    }
    
    private init() { }
    
    /// Fetch an OAuth token by making a network request
    /// - Parameters:
    ///   - code: code received from the OAuth provider
    ///   - completion: Result of the token retrieval operation
    ///
    /// It uses the NetworkClient to perform the network request, and upon receiving a response, it decodes the token from the response data using a JSONDecoder.
    /// Finally, it calls the completion handler with the result of the token retrieval operation.
    /// network client
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)

        guard lastCode != code else {
            completion(.failure(AuthServiceError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        guard
            let request = Endpoint.sendCode(code: code).request
        else {
            completion(.failure(AuthServiceError.invalidRequest))
            fatalError("cannot create URL")
        }
        
        let task = makeOAuthToken(for: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                print("DEBUG:", "Auth token stored: \(authToken)")
                completion(.success(authToken))
            case .failure(let error):
                completion(.failure(error))
            }
            self.task = nil
            self.lastCode = nil
        }
        self.task = task
        task.resume()
    }
}

// MARK: - Network Client
private extension OAuth2Service {
     func makeOAuthToken(for request: URLRequest, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) -> URLSessionTask {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return urlSession.data(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let body = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                    print("DEBUG:", "Decoded token: \(body)")
                    completion(.success(body))
                }
                catch {
                    completion(.failure(NetworkError.decodingError(error)))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
