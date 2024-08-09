//
//  Constants.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 27.06.2024.
//

import Foundation

struct Constants {
    
    enum API {
        // free access key
        static let accessKey = "9oTiliJ_ifDhqCbxo_ZPqy07nu8P8kF3dT-YKaBbkQ8"
        // free secret key
        static let secretKey = "1bKp9BHyhOnu673zLIVt__fN1EskFvBAGnQn7vc92wA"
        static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
        static let accessScope = "public+read_user+write_likes"
        static let scheme = "https"
        static let oauthBaseURL = "unsplash.com"
        static let baseURL = "api.unsplash.com"
        static let port: Int? = nil
        static let defaultBaseURL: URL = URL(staticString: "https://api.unsplash.com")
    }
}
