//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 03.06.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    //MARK: - UI Components
    lazy var cardView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        return view
    }()
    
    lazy var cardImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "0")
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .clear
        
        return view
    }()
    
    lazy var gradientView: GradientView = {
        let view = GradientView()
        view.startColor = .ypGradient
        view.endColor = .clear
        view.angle = 90
        return view
    }()
    
    lazy var likeButton: UIButton = {
        let view = UIButton(type: .custom)
        view.setImage(UIImage(named: "ic.like"), for: .normal)
        view.tintColor = .ypWhiteAlpha50
        return view
    }()
    
    lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 13, weight: .regular)
        view.textColor = .ypWhite
        view.text = "27 августа 2022"
        return view
    }()
    
    //MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ImagesListCell {
    func setupUI() {
        contentView.backgroundColor = .ypBlack
        contentView.addSubview(cardView)
        cardView.addSubview(cardImageView)
        cardView.addSubview(likeButton)
        cardView.addSubview(gradientView)
        cardView.addSubview(dateLabel)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            cardImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            cardImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            cardImageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            cardImageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            
            gradientView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 30),
            
            likeButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: cardView.topAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            likeButton.heightAnchor.constraint(equalToConstant: 44),
            
            dateLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: cardView.trailingAnchor, constant: -8),
            dateLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -8)
        ])
    }
}

// MARK: - Preview
@available(iOS 17, *)
#Preview() {
    let cell = ImagesListCell()
    return cell
}
