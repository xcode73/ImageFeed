//
//  Endpoint.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 10.07.2024.
//

import Foundation

enum Endpoint {
    
    case authorize(url: String = "/oauth/authorize")
    case sendCode(url: String = "/oauth/token", code: String)
    
    var request: URLRequest? {
        guard let url = self.url else {
            print("ERROR: cannot create URL")
            return nil
        }
        var request = URLRequest(url: url)
        request.httpMethod = self.httpMethod
        request.httpBody = self.httpBody
        request.addValues(for: self)
        return request
    }
    
    private var url: URL? {
        var components = URLComponents()
        components.scheme = Constants.API.scheme
        components.host = Constants.API.baseURL
        components.port = Constants.API.port
        components.path = self.path
        components.queryItems = self.queryItems
        return components.url
    }
    
    private var path: String {
        switch self {
        case .authorize(let url):
            return url
        case .sendCode(let url, _):
            return url
        }
    }
    
    private var queryItems: [URLQueryItem] {
        switch self {
        case .authorize:
            return [
                URLQueryItem(name: "client_id", value: Constants.API.accessKey),
                URLQueryItem(name: "redirect_uri", value: Constants.API.redirectURI),
                URLQueryItem(name: "response_type", value: "code"),
                URLQueryItem(name: "scope", value: Constants.API.accessScope)
            ]
        case .sendCode(_, let code):
            return [
                URLQueryItem(name: "client_id", value: Constants.API.accessKey),
                URLQueryItem(name: "client_secret", value: Constants.API.secretKey),
                URLQueryItem(name: "redirect_uri", value: Constants.API.redirectURI),
                URLQueryItem(name: "code", value: code),
                URLQueryItem(name: "grant_type", value: "authorization_code")
            ]
        }
    }
    
    private var httpMethod: String {
        switch self {
        case .authorize:
            return HTTP.Method.get.rawValue
        case .sendCode:
            return HTTP.Method.post.rawValue
        }
    }
    
    private var httpBody: Data? {
        switch self {
        case .authorize:
            return nil
        case .sendCode:
            return nil
//            do {
//                let jsonPost = try JSONEncoder().encode(code)
//                return jsonPost
//            } catch {
//                print("ERROR: \(error.localizedDescription)")
//                return nil
//            }
        }
    }
}

// MARK: - Request
private extension URLRequest {
    /// Add HTTP headers
    /// - Parameter endpoint: Endpoint
    mutating func addValues(for endpoint: Endpoint) {
        switch endpoint {
        case .authorize:
            break
        case .sendCode:
            self.setValue(
                HTTP.Headers.Value.applicationJson.rawValue,
                forHTTPHeaderField: HTTP.Headers.Key.contentType.rawValue
            )
        }
    }
}
