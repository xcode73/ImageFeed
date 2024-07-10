//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 28.06.2024.
//

import UIKit
import WebKit

enum WebViewConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

final class WebViewViewController: UIViewController {
    
    let service = APIService()
    weak var delegate: WebViewViewControllerDelegate?
    
    // MARK: - Outlets
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    
    // MARK: - Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // NOTE: Since the class is marked as `final` we don't need to pass a context.
        // In case of inhertiance context must not be nil.
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
        updateProgress()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        progressView.progress = 0
        loadAuthView()
        updateProgress()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
    
    // MARK: - Methods
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    // MARK: - Actions
    @IBAction func didTapBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
}

// MARK: - Private
private extension WebViewViewController {
    func loadAuthView() {
//        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
//            print("Error: cannot create URLComponents")
//            return
//        }
//        
//        urlComponents.queryItems = [
//            URLQueryItem(name: "client_id", value: Constants.accessKey),
//            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
//            URLQueryItem(name: "response_type", value: "code"),
//            URLQueryItem(name: "scope", value: Constants.accessScope)
//        ]
//        
//        guard let url = urlComponents.url else {
//            print("ERROR: cannot create URL")
//            return
//        }
        
//        let request = URLRequest(url: url)
        guard let request = Endpoint.fetchCode().request else {
            print("ERROR: cannot create URL")
            return
        }
        
        print("INFO: Auth request:", request)
        
        webView.load(request)
    }
    
    func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
}

// MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    // Этот метод вызывается, когда в результате действий пользователя WKWebView готовится совершить навигационные действия (например, загрузить новую страницу). Благодаря этому мы узнаем, когда пользователь успешно авторизовался.
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}

// MARK: - Preview
@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: "WebVC") as! WebViewViewController
    return viewController
}
