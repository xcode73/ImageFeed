//
//  NetworkClient.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 11.07.2024.
//

import Foundation

protocol NetworkRouting {
    func fetch(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void)
}
/// Отвечает за загрузку данных
//struct NetworkClient: NetworkRouting {
//    private enum NetworkError: Error {
//        case httpStatusCode(Int)
//        case urlRequestError(Error)
//        case urlSessionError
//        case badRequest
//        case unauthorized
//        case forbidden
//        case notFound
//        case serverError
//    }
//    
//    /// Fetch data using the given URL request
//    /// - Parameters:
//    ///   - request: A URL request object that provides the URL, request type, body data
//    ///   - completion: The completion handler to call when the load request is complete.
//    func fetch(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
//        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
//            DispatchQueue.main.async {
//                completion(result)
//            }
//        }
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
//                switch statusCode {
//                case 200...299:
//                    print("DEBUG:", "Received success HTTP status code: \(statusCode)")
//                    fulfillCompletionOnTheMainThread(.success(data))
//                case 400:
//                    print("ERROR:", "Bad request \(statusCode)")
//                    fulfillCompletionOnTheMainThread(.failure(NetworkError.badRequest))
//                case 401:
//                    print("ERROR:", "Unauthorized \(statusCode) - Invalid Access Token")
//                    fulfillCompletionOnTheMainThread(.failure(NetworkError.unauthorized))
//                case 403:
//                    print("ERROR:", "Forbidden \(statusCode)")
//                    fulfillCompletionOnTheMainThread(.failure(NetworkError.forbidden))
//                case 404:
//                    print("ERROR:", "Not Found \(statusCode)")
//                    fulfillCompletionOnTheMainThread(.failure(NetworkError.notFound))
//                    
//                case 500, 503:
//                    print("ERROR:", "Internal Server Error \(statusCode)")
//                    fulfillCompletionOnTheMainThread(.failure(NetworkError.serverError))
//                default:
//                    print("ERROR:", "HTTP status code: \(statusCode)")
//                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
//                }
//            } else if let error = error {
//                print("ERROR:", error.localizedDescription)
//                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
//            } else {
//                print("ERROR: Unknown error")
//                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
//            }
//        }
//        task.resume()
//    }
//}
