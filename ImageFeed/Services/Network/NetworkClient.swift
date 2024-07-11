//
//  NetworkClient.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 11.07.2024.
//

import Foundation

protocol NetworkRouting {
    func fetch(with request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void)
}
/// Отвечает за загрузку данных
struct NetworkClient: NetworkRouting {

    enum NetworkError: Error {
        case httpStatusCode(Int)
        case urlRequestError(Error)
        case urlSessionError
    }
    
    func fetch(with request: URLRequest, completion: @escaping (Result<Data, Error>)  -> Void) {
        
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in

            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        }
        task.resume()
    }
}
