//
//  ThumbnailViewController.swift
//  PhotoViewer
//
//  Created by Bircan, Korhan on 5/17/17.
//  Copyright © 2017 Korhan. All rights reserved.
//

import UIKit

import AlamofireImage
import NVActivityIndicatorView
import SwiftyBeaver

class ThumbnailViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!

    fileprivate let allowedNumberOfRemainingScreens = 1
    fileprivate let dataSource = ImageDataSource()
    fileprivate let minKeyStrokeIntervalSeconds = 0.5
    fileprivate let minKeyStrokeIntervalMilliseconds = 500 // DispatchTimeInterval expects an Int.
    fileprivate let dispatchInterval = 1
    fileprivate var lastFetchDate = Date()
    fileprivate var numberOfRemainingScreens: Int = 0 {
        didSet {
            if numberOfRemainingScreens < allowedNumberOfRemainingScreens {
                SwiftyBeaver.debug("should request more images")
                dataSource.requestMoreThumbnails() { thumbnails in
                    DispatchQueue.main.async {
                        var indexPaths = [IndexPath]()
                        let totalCount = self.dataSource.thumbnails.count
                        for row in (totalCount - thumbnails.count)..<totalCount {
                            indexPaths.append(IndexPath(row: row, section: 0))
                        }
                        self.collectionView.insertItems(at: indexPaths)
                    }
                }
            }
        }
    }
    fileprivate var keyword: String = "" {
        didSet {
            keyword = keyword.trimRedundantWhitespace()
        }
    }

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

extension ThumbnailViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        numberOfRemainingScreens = Int((scrollView.contentSize.height - scrollView.contentOffset.y) / scrollView.frame.height) - 1

        searchBar.resignFirstResponder()
    }
}

extension ThumbnailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let keyword = searchBar.text, !keyword.isEmpty else {
            return 0
        }

        return dataSource.thumbnails.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let thumbnail = dataSource.thumbnails[indexPath.row]
        return ThumbnailViewModel.cellForThumbnail(thumbnail, collectionView: collectionView, indexPath: indexPath)
    }
}

extension ThumbnailViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        requestThumbnailsFor(keyword: keyword.trimRedundantWhitespace())
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        requestThumbnailsFor(keyword: keyword.trimRedundantWhitespace())

        searchBar.resignFirstResponder()
    }

    fileprivate func requestThumbnailsFor(keyword: String) {
        guard let keyword = searchBar.text else {
            return
        }

        let now = Date()
        let interval = now.timeIntervalSince(lastFetchDate)

        // If the user has stopped typing we can send a network request. Otherwise, it's either too
        // soon or the user is still typing.
        if interval >= minKeyStrokeIntervalSeconds && keyword == self.keyword {
            SwiftyBeaver.debug("Last query old enough \(interval)s, requesting thumbnails for keyword:\(self.keyword)")
            activityIndicator.startAnimating()
            dataSource.thumbnailsForKeyword(keyword) {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.collectionView.reloadData()
                }
            }
        } else {
            SwiftyBeaver.debug("Last query too soon \(interval)s, query:\(self.keyword). Dispatching \(minKeyStrokeIntervalMilliseconds)ms later")
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(dispatchInterval)) {
                if keyword == self.keyword {
                    self.requestThumbnailsFor(keyword: keyword)
                }
            }
        }

        self.keyword = keyword
        lastFetchDate = now
    }
}
