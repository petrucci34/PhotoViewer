//
//  ThumbnailViewModel.swift
//  PhotoViewer
//
//  Created by Bircan, Korhan on 5/20/17.
//  Copyright © 2017 Korhan. All rights reserved.
//

import UIKit

struct ThumbnailViewModel {
    static func cellForThumbnail(_ thumbnail: Thumbnail, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.description(), for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }

        cell.imageView.image = nil // Release the previous image.
        cell.activityIndicator.startAnimating()
        cell.imageView.af_setImage(withURL: thumbnail.thumbnailSizeUrl!,
            placeholderImage: nil,
            filter: nil,
            progress: nil,
            progressQueue: DispatchQueue.main,
            imageTransition: .crossDissolve(0.2),
            runImageTransitionIfCached: true) { image in
                cell.activityIndicator.stopAnimating()
        }

        return cell
    }
}
