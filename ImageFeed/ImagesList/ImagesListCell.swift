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
    private var cardImageView: UIImageView!
    
    @IBOutlet 
    private var likeButton: UIButton!
    
    @IBOutlet 
    private var dateLabel: UILabel!
    

    func configureCell(image: UIImage?, date: String, isLiked: Bool) {
        cardImageView.image = image
        dateLabel.text = date

        let likeIcon = isLiked ? UIImage(named: "ic.like.active") : UIImage(named: "ic.like.not.active")
        likeButton.setImage(likeIcon, for: .normal)
    }

}
