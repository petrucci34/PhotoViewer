//
//  ThumbnailViewController.swift
//  PhotoViewer
//
//  Created by Bircan, Korhan on 5/17/17.
//  Copyright © 2017 Korhan. All rights reserved.
//

import UIKit

import AlamofireImage
import SwiftyBeaver

class ThumbnailViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!

    fileprivate let allowedNumberOfRemainingScreens = 1
    fileprivate let dataSource = ImageDataSource()
    fileprivate var numberOfRemainingScreens: Int = 0 {
        didSet {
            if numberOfRemainingScreens < allowedNumberOfRemainingScreens {
                SwiftyBeaver.debug("should request more images")
                dataSource.requestMoreThumbnails() {
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    fileprivate var lastFetchDate = Date()

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.collectionViewLayout = CustomLayout()
    }

    // Make sure we preserve the number of columns when orientation changes.
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let photoViewController = segue.destination as? PhotoViewController else {
            return
        }

        if let indexPath = collectionView.indexPathsForSelectedItems?.first {
            photoViewController.thumbnail = dataSource.thumbnails[indexPath.row]
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        numberOfRemainingScreens = Int((scrollView.contentSize.height - scrollView.contentOffset.y) / scrollView.frame.height) - 1
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let keyword = searchBar.text, !keyword.isEmpty else {
            return 0
        }

        return dataSource.thumbnails.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.description(), for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }

        let thumbnail = dataSource.thumbnails[indexPath.row]
        cell.imageView.af_setImage(withURL: thumbnail.thumbnailSizeUrl!,
                                   placeholderImage: ImageDataSource.placeholderImage,
                                   imageTransition: .crossDissolve(0.2))

        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        SwiftyBeaver.debug("searchbar text: \(searchBar.text!)")
        dataSource.thumbnailsForKeyword(searchBar.text) {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}
