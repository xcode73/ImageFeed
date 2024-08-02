//
//  URLSession+object.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 7/31/24.
//

import Foundation

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let task = data(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let object = try decoder.decode(T.self, from: data)
                    completion(.success(object))
                }
                catch {
                    print("DEBUG",
                          "[\(String(describing: self)).\(#function)]:",
                          "Decoding error: \(error.localizedDescription), data: \(String(data: data, encoding: .utf8) ?? "")")
                    completion(.failure(NetworkError.decodingError(error)))
                } 
            case .failure(let error):
                print("DEBUG",
                      "[\(String(describing: self)).\(#function)]:",
                      NetworkError.urlRequestError(error),
                      error.localizedDescription)
                completion(.failure(error))
            }
        }
        return task
    }
}
