//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Nikolai Eremenko on 13.06.2024.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage? = UIImage(named: "0") {
        didSet {
            guard isViewLoaded, let image else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    // MARK: - Outlets
    @IBOutlet
    private var imageView: UIImageView!
    
    @IBOutlet
    private var scrollView: UIScrollView!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.6
        scrollView.maximumZoomScale = 3.25
        
        guard let image else { return }
        imageView.image = image
        imageView.frame.size = image.size
        
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale,
                                          max(hScale, vScale)
                                         )
        )
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    // MARK: - Actions
    @IBAction func didTapBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
        guard let image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }
}

// MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    // center image in scroll view after zoom
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max(0, (scrollView.bounds.width - scrollView.contentSize.width) * 0.5)
        let offsetY = max(0, (scrollView.bounds.height - scrollView.contentSize.height) * 0.5)
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)
    }
}

// MARK: - Preview
@available(iOS 17, *)
#Preview() {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: "ImageVC") as! SingleImageViewController
    return viewController
}
