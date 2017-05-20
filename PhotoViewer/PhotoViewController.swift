//
//  PhotoViewController.swift
//  PhotoViewer
//
//  Created by Bircan, Korhan on 5/18/17.
//  Copyright © 2017 Korhan. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class PhotoViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    var thumbnail: Thumbnail?

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = thumbnail?.title

        activityIndicator.startAnimating()
        if let imageURL = thumbnail?.url {
            imageView.af_setImage(withURL: imageURL, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: false, completion: { (image) in
                self.activityIndicator.stopAnimating()
            })
        }
    }
}

extension PhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
