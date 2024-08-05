//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 28.06.2024.
//

import UIKit
import ProgressHUD

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}



final class AuthViewController: UIViewController {
    // MARK: - Properties
    weak var delegate: AuthViewControllerDelegate?
    private let oauth2Service = OAuth2Service.shared
    
    // MARK: - UI Components
    private lazy var authButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.backgroundColor = .ypWhite
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        button.setTitleColor(.ypBlack, for: .normal)
        button.setTitle("Войти", for: .normal)
        button.addTarget(self, action: #selector(switchToWebViewController), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic.unsplash")
        imageView.tintColor = .ypWhite
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
//        configureBackButton()

//        show()
    }
    
//    private func show() {
//    //        let symbol = "ic.loader"
//        ProgressHUD.colorBackground = .ypBackground
//        ProgressHUD.animationType = .activityIndicator
//        
//        ProgressHUD.colorAnimation = .ypBlack
//        
//        
//        
//        ProgressHUD.colorHUD = .ypWhiteAlpha50
////        ProgressHUD.color = 
//      
//        
//        ProgressHUD.mediaSize = 51
//        ProgressHUD.marginSize = 13
//        ProgressHUD.animate(nil, interaction: false)
//        
//        
//    }
}

private extension AuthViewController {
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        oauth2Service.fetchOAuthToken(code) { result in
            completion(result)
        }
    }
    
    // MARK: - Actions
    @objc
    func switchToWebViewController() {
        let webViewController = WebViewViewController()
        
        webViewController.delegate = self
        
        webViewController.modalPresentationStyle = .overFullScreen
        present(webViewController, animated: true)
    }
    
    // MARK: - Constraints
    func setupViews() {
        view.backgroundColor = UIColor(named: "YPBlack")
        view.addSubview(logoImageView)
        view.addSubview(authButton)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 60),
            logoImageView.heightAnchor.constraint(equalToConstant: 60),
            authButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            authButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            authButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90),
            authButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}

// MARK: - AuthViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        
        vc.dismiss(animated: true)
        
        UIBlockingProgressHUD.show()
        
        fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                UIBlockingProgressHUD.dismiss()
                self.delegate?.didAuthenticate(self)
            case .failure:
                let alertModel = AlertModel(
                    title: "Что-то пошло не так!",
                    message: "Не удалось войти в систему.",
                    buttons: ["OK"],
                    identifier: "AuthError",
                    completion: {
                        vc.dismiss(animated: true)
                    }
                )
                UIBlockingProgressHUD.dismiss()
                AlertPresenter.showAlert(on: self, model: alertModel)
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}

// MARK: - Preview
@available(iOS 17, *)
#Preview() {
    AuthViewController()
}
