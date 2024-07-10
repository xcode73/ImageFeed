//
//  APIService.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 10.07.2024.
//

import Foundation

enum APIError: Error {
    case urlSessionError(String)
    case serverError(String = "Invalid API Key")
    case invalidResponse(String = "Invalid response from server.")
    case decodingError(String = "Error parsing server response.")
}

protocol Service {
    func makeRequest<T: Codable>(with request: URLRequest, respModel: T.Type, completion: @escaping (T?, APIError?) -> Void)
}

class APIService: Service {
    
    func makeRequest<T: Codable>(with request: URLRequest,
                                 respModel: T.Type,
                                 completion: @escaping (T?, APIError?) -> Void) {
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, .urlSessionError(error.localizedDescription))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 || response.statusCode != 201 {
                completion(nil, .serverError())
                return
            }
            
            guard let data = data else {
                completion(nil, .invalidResponse())
                return
            }

            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(result, nil)
                
            } catch let err {
                print(err)
                completion(nil, .decodingError())
                return
            }
             
        }.resume()
    }
}
