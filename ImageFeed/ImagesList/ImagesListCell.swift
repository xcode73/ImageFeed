//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 03.06.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    

    @IBOutlet
    private var cardView: UIView! {
        didSet {
            cardView.layer.masksToBounds = true
            cardView.layer.cornerRadius = 16
        }
    }
    
    
    @IBOutlet 
    weak var cardImageView: UIImageView!
    
    
    
    @IBOutlet
    weak var likeButton: UIButton!
    
    
    @IBOutlet weak var dateLabel: UILabel!
    


}
