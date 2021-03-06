//
//  ImageDataSource.swift
//  PhotoViewer
//
//  Created by Bircan, Korhan on 5/17/17.
//  Copyright © 2017 Korhan. All rights reserved.
//

import Foundation
import SwiftyBeaver

typealias VoidCompletionBlock = (() -> Void)
typealias ThumbnailsCompletionBlock = (([Thumbnail]) -> Void)

class ImageDataSource {
    static let placeholderImage = UIImage(named: "placeholderImage")

    var keyword = ""
    var thumbnails = [Thumbnail]()
    var currentPage = 1
    var imagesPerPage = 50
    private var requestInFlight = false

    func thumbnailsForKeyword(_ keyword: String?, completion: @escaping VoidCompletionBlock) {
        guard let keyword = keyword, !requestInFlight else {
            return
        }

        self.keyword = keyword
        thumbnails.removeAll()

        requestInFlight = true
        NetworkManager.sharedInstance.fetchThumbnailData(imagesPerPage: imagesPerPage, page: currentPage,
            keyword: keyword) { thumbnails in
                self.thumbnails = thumbnails
                self.requestInFlight = false
                completion()
        }
    }

    func requestMoreThumbnails(completion: @escaping ThumbnailsCompletionBlock) {
        guard !requestInFlight else {
            return
        }

        requestInFlight = true
        currentPage += 1
        SwiftyBeaver.debug("Requesting more images: currentPage: \(currentPage)")

        NetworkManager.sharedInstance.fetchThumbnailData(imagesPerPage: imagesPerPage, page: currentPage,
            keyword: keyword) { thumbnails in
                self.thumbnails.append(contentsOf: thumbnails)
                self.requestInFlight = false
                completion(thumbnails)
        }
    }
}
