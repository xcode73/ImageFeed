//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 10.07.2024.
//

import UIKit

final class SplashViewController: UIViewController {
    
    // MARK: - Properties
    private let profileService = ProfileService.shared
    private let imageService = ProfileImageService.shared
    private let storage = OAuth2TokenStorage()
    private let oAuth2Service = OAuth2Service.shared
    //    private let showAuthenticationScreenSegueIdentifier = "ShowAuth"
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic.splashscreen")
        imageView.tintColor = UIColor(named: "YPWhite")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = storage.token {
            fetchProfile(token)
        } else {
            switchToAuthViewController()
        }
    }
}

private extension SplashViewController {
    
    // MARK: - Navigation
    func switchToAuthViewController() {
        // storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard
            let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthVC") as? AuthViewController
        else {
            return
        }
        
        authViewController.delegate = self
        
        let navigationController = UINavigationController(rootViewController: authViewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
        
        // code
    }
    
    func switchToTabBarController() {
        let tabBarController = TabBarController()
        
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        window.rootViewController = tabBarController
    }
    
    // MARK: - Fetching
    func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            switch result {
            case .success(let profile):
                fetchProfileImageURL(username: profile.username)
                self.switchToTabBarController()
            case .failure(let error):
                print("ERROR:", "ProfileService error: \(error.localizedDescription)")
                break
            }
        }
    }
    
    private func fetchProfileImageURL(username: String) {
        imageService.fetchProfileImageURL(username: username) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.switchToTabBarController()
            case .failure(let error):
                print("ERROR:", "ProfileImageService error: \(error.localizedDescription)")
                break
            }
        }
    }
    
    
    // MARK: - Constraints
    func setupViews() {
        view.backgroundColor = UIColor(named: "YPBlack")
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        
        vc.dismiss(animated: true)
        
        guard let token = storage.token else {
            return
        }
        
        fetchProfile(token)
        
        switchToTabBarController()
    }
}

// MARK: - Preview
@available(iOS 17, *)
#Preview() {
    SplashViewController()
}
