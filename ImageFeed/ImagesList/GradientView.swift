//
//  GradientView.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 04.06.2024.
//

import UIKit

class GradientView: UIView {
    
    enum Point {
        case topLeading
        case leading
        case bottomLeading
        case top
        case center
        case bottom
        case topTrailing
        case trailing
        case bottomTrailing
        
        var point: CGPoint {
            switch self {
            case .topLeading:
                return CGPoint(x: 0, y: 0)
            case .leading:
                return CGPoint(x: 0, y: 0.5) 
            case .bottomLeading:
                return CGPoint(x: 0, y: 1.0)
            case .top:
                return CGPoint (x: 0.5, y: 0)
            case .center:
                return CGPoint(x: 0.5, y: 0.5)
            case . bottom:
                return CGPoint(x: 0.5, y: 1.0)
            case .topTrailing:
                return CGPoint(x: 1.0, y: 0.0)
            case .trailing:
                return CGPoint(x: 1.0, y: 0.5)
            case .bottomTrailing:
                return CGPoint(x: 1.0, y: 1.0)
            }
        }
    }
    
    @IBInspectable 
    private var startColor: UIColor? {
        didSet {
            setUpGradientColors()
        }
    }
    
    @IBInspectable 
    private var endColor: UIColor? {
        didSet {
            setUpGradientColors()
        }
    }
    
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpGradientLayer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private func setUpGradientLayer() {
        self.layer.addSublayer(gradientLayer)
        setUpGradientColors()
        gradientLayer.startPoint = Point.top.point
        gradientLayer.endPoint = Point.bottom.point
    }
    
    private func setUpGradientColors() {
        if let startColor = startColor, let endColor = endColor {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        }
    }
}
