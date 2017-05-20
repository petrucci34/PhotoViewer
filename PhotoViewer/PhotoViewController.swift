//
//  PhotoViewController.swift
//  PhotoViewer
//
//  Created by Bircan, Korhan on 5/18/17.
//  Copyright © 2017 Korhan. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var thumbnail: Thumbnail?

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = thumbnail?.title

        if let imageURL = thumbnail?.url {
            imageView.af_setImage(withURL: imageURL,
                                  placeholderImage: ImageDataSource.placeholderImage,
                                  imageTransition: .crossDissolve(0.2))
        }
    }
}
