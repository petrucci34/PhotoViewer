//
//  NetworkManagerTests.swift
//  PhotoViewer
//
//  Created by Bircan, Korhan on 5/20/17.
//  Copyright © 2017 Korhan. All rights reserved.
//

import XCTest
@testable import PhotoViewer

class NetworkManagerTests: XCTestCase {
    func testBaseURL() {
        let imagesPerPage = 100
        let page = 1
        var keyword = "hello"
        let firstURLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=675894853ae8ec6c242fa4c077bcf4a0&text=\(keyword)&extras=url_s&format=json&nojsoncallback=1&per_page=\(imagesPerPage)&page=\(page)"
        let firstURL = URL(string: firstURLString)
        XCTAssertEqual(firstURL, NetworkManager.sharedInstance.baseURL(imagesPerPage: imagesPerPage, page: page, keyword: keyword))

        keyword = "hello world"
        let encodedKeyword = "hello%20world"
        let secondURLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=675894853ae8ec6c242fa4c077bcf4a0&text=\(encodedKeyword)&extras=url_s&format=json&nojsoncallback=1&per_page=\(imagesPerPage)&page=\(page)"
        let secondURL = URL(string: secondURLString)
        XCTAssertEqual(secondURL, NetworkManager.sharedInstance.baseURL(imagesPerPage: imagesPerPage, page: page, keyword: keyword))
    }
    
}
