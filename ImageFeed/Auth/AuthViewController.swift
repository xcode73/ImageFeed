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
    private let showWebViewSegueIdentifier = "ShowWebView"
    private let oauth2Service = OAuth2Service.shared
    
    weak var delegate: AuthViewControllerDelegate?
    
    @IBOutlet
    private var authButton: UIButton! {
        didSet {
            authButton.layer.cornerRadius = 16
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureBackButton()
    }
}

extension AuthViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else {
                assertionFailure("Invalid destination \(showWebViewSegueIdentifier)")
                return
            }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

// MARK: - Private methods
private extension AuthViewController {
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "ic.backward")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "ic.backward")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YPBlack")
    }
    
    private func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        oauth2Service.fetchOAuthToken(code: code) { result in
            completion(result)
        }
    }
}

// MARK: - AuthViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        ProgressHUD.animate()
        
        fetchOAuthToken(code) { [weak self] result in
            ProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.delegate?.didAuthenticate(self)
                print("DEBUG:", "AuthViewController Delegate called")
            case .failure:
                // TODO [Sprint 11] Добавьте обработку ошибки
                break
            }
            
            vc.dismiss(animated: true)
            print("DEBUG:", "WebViewViewController dismissed")
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}

// MARK: - Preview
@available(iOS 17, *)
#Preview() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: "AuthVC") as! AuthViewController
    return viewController
}
