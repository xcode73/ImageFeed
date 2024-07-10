//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 28.06.2024.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    /// WebViewViewController получил код
    /// - Parameters:
    ///   - vc: ViewController
    ///   - code: код из url
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    /// пользователь нажал кнопку назад и отменил авторизацию
    /// - Parameter vc: ViewController
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
