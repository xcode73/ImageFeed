//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 13.06.2024.
//

import UIKit

final class ProfileViewController: UIViewController {
    //MARK: - UI
    private lazy var profileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 3
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var profilePhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "img.photo")
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "ic.exit"), for: [])
        button.tintColor = UIColor(named: "YPRed")
        // action
        button.addTarget(self, action: #selector(logoutAction(sender:)), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        label.textColor = UIColor(named: "YPWhite")
        label.text = "Екатерина Новикова"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = UIColor(named: "YPGray")
        label.text = "@ekaterina_nov"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var aboutLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = UIColor(named: "YPWhite")
        label.text = "Hello, world!"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }

    // MARK: - Constraints
    private func setupViews() {
        view.backgroundColor = UIColor(named: "YPBlack")
        view.addSubview(profileStackView)
        profileStackView.addArrangedSubview(headerStackView)
        profileStackView.addArrangedSubview(fullNameLabel)
        profileStackView.addArrangedSubview(nickNameLabel)
        profileStackView.addArrangedSubview(aboutLabel)
        headerStackView.addArrangedSubview(profilePhoto)
        headerStackView.addArrangedSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            profileStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            profilePhoto.widthAnchor.constraint(equalToConstant: 70),
            profilePhoto.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    //MARK: - Actions
    @objc private func logoutAction(sender: UIButton!) {
        print("Logout button tapped")
    }
}

// MARK: - Preview
@available(iOS 17, *)
#Preview() {
    ProfileViewController()
}
