//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 19.07.2024.
//

import Foundation

final class ProfileService {
    // MARK: - properties
    static let shared = ProfileService()
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    // MARK: - Init
    private init() { }
    
    // MARK: - Public methods
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard
            let request = Endpoint.getProfile(token: token).request
        else {
            completion(.failure(AuthServiceError.invalidRequest))
            fatalError("cannot create URL")
        }
        print("DEBUG:", "Profile request headers \(request.allHTTPHeaderFields ?? [:])")
        
        let task = makeProfileResult(for: request) { [weak self] result in
            guard let self = self
            else {
                return
            }
            switch result {
            case .success(let profileResult):
                let profile = Profile(from: profileResult)
                self.profile = profile
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
            self.task = nil
        }
        self.task = task
        task.resume()
    }
}

// MARK: - Private
private extension ProfileService {
    func makeProfileResult(for request: URLRequest, completion: @escaping (Result<ProfileResult, Error>) -> Void) -> URLSessionTask {
       let decoder = JSONDecoder()
       decoder.keyDecodingStrategy = .convertFromSnakeCase
       return urlSession.data(for: request) { (result: Result<Data, Error>) in
           switch result {
           case .success(let data):
               do {
                   let profileResult = try decoder.decode(ProfileResult.self, from: data)
                   print("DEBUG:", "Profile decoded: \(profileResult)")
                   completion(.success(profileResult))
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
