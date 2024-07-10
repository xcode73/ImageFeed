//
//  Constants.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 27.06.2024.
//

import Foundation

enum Constants {
    static let accessKey = "9oTiliJ_ifDhqCbxo_ZPqy07nu8P8kF3dT-YKaBbkQ8"
    static let secretKey = "1bKp9BHyhOnu673zLIVt__fN1EskFvBAGnQn7vc92wA"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let scheme = "https"
    static let baseURL = "unsplash.com"
    static let port: Int? = nil
    static let defaultBaseURL: URL = URL(string: "https://api.unsplash.com")!
}
