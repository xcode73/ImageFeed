//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 09.07.2024.
//

import Foundation

struct OAuthTokenResponseBody: Codable {
    let accessToken: String
    let tokenType: String
}
