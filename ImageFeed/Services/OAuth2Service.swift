//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 07.07.2024.
//

import Foundation

enum OAuth2ServiceConstants {
    static let unsplashTokenURLString = "https://unsplash.com/oauth/token"
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() { }
    
    /// Получает авторизационный токен
    /// - Parameters:
    ///   - code: код полученный из редиректа в webview
    ///   - completion: функция возврата
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        // создание URLRequest с помощью метода request
        guard let request = tokenRequest(forCode: code) else {
            print("ERROR: Cannot create token request")
            completion(.failure(URLError(.badURL)))
            return
        }
        
        print("INFO: Fetching token with request:", request)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let data = data,
                  let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                print("ERROR: No data or HTTP status code in 2xx range")
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                
                if let accessToken = json?["access_token"] as? String {
                    print("INFO: Fetched access token:", accessToken)
                    completion(.success(accessToken))
                } else {
                    print("ERROR: Failed to fetch access token from json")
                    completion(.failure(URLError(.badServerResponse)))
                }
            } catch {
                print("ERROR: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        task.resume()
        print("INFO: Resume task:", task)
    }
}

// MARK: - Private
private extension OAuth2Service {
    /// Создает URLRequest для получения авторизационного токена
    /// - Parameter code: код полученный из редиректа в webview
    /// - Returns: URLRequest
    func tokenRequest(forCode code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: OAuth2ServiceConstants.unsplashTokenURLString) else {
            print("ERROR: cannot create URLComponents")
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else {
            print("ERROR: cannot create URL")
            return nil
        }
        print("INFO: Token url:", url)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        print("INFO: Token request:", request)
        
        return request
    }
}
