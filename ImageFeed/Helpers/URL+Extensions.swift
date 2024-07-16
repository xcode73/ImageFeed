//
//  URL+Extensions.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 16.07.2024.
//

import Foundation

/// Extension provides an additional initializer that takes a StaticString parameter and attempts to create a URL from it.
/// This allows for easy creation of URLs from static string values.
extension URL {
    init(staticString string: StaticString) {
        guard let url = URL(string: "\(string)") else {
            preconditionFailure("Invalid static URL string: \(string)")
        }

        self = url
    }
}
