//
//  UITableViewCell+Extensions.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 13.06.2024.
//

import UIKit

extension UITableViewCell {
    /// Создает reuseIdentifier из названия файла типа UITableViewCell
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
