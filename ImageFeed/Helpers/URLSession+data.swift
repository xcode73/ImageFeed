//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 08.07.2024.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

extension URLSession {
    /// Создает задачу которая получает содержимое URL
    /// - Parameters:
    ///   - request: <#request description#>
    ///   - completion: <#completion description#>
    /// - Returns: <#description#>
    func data(for request: URLRequest,
              completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    // Возвращаем полученное тело ответа как успешный результат работы запроса.
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    // Возвращаем ошибку, связанную с неблагоприятным диапазоном статуса кода ответа
                    // это все варианты, которые попали в 3хх, 4хх и 5хх
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                // // Возвращаем сетевую ошибку
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error)))
            } else {
                // Возвращаем ошибку, связанную с остальными случаями.
                // Здесь мы, скорее всего, не получили ни тело ответа, ни ошибку
                // это непонятное состояние тоже засчитаем как ошибку работы запроса данных.
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError))
            }
        })
        
        return task
    }
}
