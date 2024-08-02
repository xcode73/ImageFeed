//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 29.07.2024.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    
    private let urlSession = URLSession.shared
    private let storage = OAuth2TokenStorage()
    
    private var task: URLSessionTask?
    private(set) var avatarURL: String?
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private init() { }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
   
        guard
            let token = storage.token
        else {
            completion(.failure(AuthServiceError.tokenNotFound))
            return
        }
        
        guard
            let request = Endpoint.getProfileImage(token: token, username: username).request
        else {
            completion(.failure(NetworkError.invalidRequest))
            fatalError("cannot create URL")
        }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let object):
                let profileImageURL = object.profileImage.large
                completion(.success(profileImageURL))
                
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": profileImageURL]
                )
                
                self.avatarURL = profileImageURL
            case .failure(let error):
                print("DEBUG",
                      "[\(String(describing: self)).\(#function)]:",
                      "Error while fetching profile image url:",
                      error.localizedDescription)
                
                completion(.failure(error))
            }
            self.task = nil
        }
        
        self.task = task
        task.resume()
    }
}
