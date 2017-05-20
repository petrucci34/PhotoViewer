//
//  CustomLayout.swift
//  PhotoViewer
//
//  Created by Bircan, Korhan on 5/17/17.
//  Copyright © 2017 Korhan. All rights reserved.
//

import UIKit

class CustomLayout: UICollectionViewFlowLayout {
    var numberOfColumns = 3

    override init() {
        super.init()

        setUpLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpLayout()
    }

    override var itemSize: CGSize {
        set {
        }
        get {
            guard let collectionView = collectionView else {
                return .zero
            }

            let itemWidth = (collectionView.frame.width - CGFloat(numberOfColumns - 1)) / CGFloat(numberOfColumns)
            return CGSize(width: itemWidth, height: itemWidth)
        }
    }

    func setUpLayout() {
        minimumInteritemSpacing = 1
        minimumLineSpacing = 1
        scrollDirection = .vertical
    }
}
