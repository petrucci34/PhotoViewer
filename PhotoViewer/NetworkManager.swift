//
//  NetworkManager.swift
//  PhotoViewer
//
//  Created by Bircan, Korhan on 5/17/17.
//  Copyright © 2017 Korhan. All rights reserved.
//

import Foundation

import AlamofireImage
import SwiftyBeaver
import SwiftyJSON

typealias ThumbnailCompletionBlock = (([Thumbnail]) -> Void)

struct NetworkManager {
    static let sharedInstance = NetworkManager()

    private let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    private let imageDownloader = ImageDownloader(
        configuration: ImageDownloader.defaultURLSessionConfiguration(),
        downloadPrioritization: .fifo,
        maximumActiveDownloads: 10,
        imageCache: AutoPurgingImageCache()
    )
    private let imageCache = AutoPurgingImageCache()

    private init() {
    }

    func fetchThumbnailData(imagesPerPage: Int, page: Int, keyword: String, completion: @escaping ThumbnailCompletionBlock) {
        guard keyword.characters.count > 0, let url = baseURL(imagesPerPage: imagesPerPage, page: page, keyword: keyword) else {
            completion([])
            return
        }

        var urlRequest = URLRequest(url: url,
                                    cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                    timeoutInterval: 10.0 * 1000)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = defaultSession.dataTask(with: urlRequest) { (data, response, error) -> Void in
            guard error == nil, let jsonData = data else {
                SwiftyBeaver.error("Error while fetching images: \(String(describing: error))")
                completion([])
                return
            }

            let json = JSON(data: jsonData)
            let thumbnails = ThumbnailParser.parseThumbnails(json: json)
            completion(thumbnails)
        }

        task.resume()
    }

    private func baseURL(imagesPerPage: Int, page: Int, keyword: String) -> URL? {
        guard let encodedKeyword = keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return nil
        }

        let urlString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=675894853ae8ec6c242fa4c077bcf4a0&text=\(encodedKeyword)&extras=url_s&format=json&nojsoncallback=1&per_page=\(imagesPerPage)&page=\(page)"
        return URL(string: urlString)
    }
}
