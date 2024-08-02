//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 31.07.2024.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttons: [String]
    let identifier: String
    let completion: () -> Void
}
