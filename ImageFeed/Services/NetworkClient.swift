//
//  NetworkClient.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 10.07.2024.
//

import Foundation

protocol NetworkRouting {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
/// Отвечает за загрузку данных по URL
struct NetworkClient: NetworkRouting {

    private enum NetworkError: Error {
        case codeError
    }
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                handler(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode < 200 || response.statusCode >= 300 {
                handler(.failure(NetworkError.codeError))
                return
            }
            
            guard let data = data else { return }
            handler(.success(data))
        }
        task.resume()
    }
}

private extension NetworkClient {
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
