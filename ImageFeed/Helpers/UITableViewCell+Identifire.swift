//
//  UITableViewCell+Extensions.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 13.06.2024.
//

import UIKit

/// This extension provides a computed static property reuseIdentifier that returns the string representation of the class name.
extension UITableViewCell {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
