//
//  ThumbnailTests.swift
//  PhotoViewer
//
//  Created by Bircan, Korhan on 5/20/17.
//  Copyright © 2017 Korhan. All rights reserved.
//

import XCTest
@testable import PhotoViewer
@testable import SwiftyJSON

class ThumbnailTests: XCTestCase {
    let jsonString = "{\"photos\":{\"page\":1,\"pages\":612508,\"perpage\":1,\"total\":\"612508\",\"photo\":[{\"id\":\"33976528863\",\"owner\":\"56396948@N08\",\"secret\":\"dc5a2e82cf\",\"server\":\"4274\",\"farm\":5,\"title\":\"Hello.Moray\",\"ispublic\":1,\"isfriend\":0,\"isfamily\":0,\"url_s\":\"https://farm5.staticflickr.com/4274/33976528863_dc5a2e82cf_m.jpg\",\"height_s\":\"234\",\"width_s\":\"240\"}]},\"stat\":\"ok\"}"
    var json: JSON?
    
    override func setUp() {
        super.setUp()

        json = JSON(parseJSON: jsonString)
    }
    
    func testThumbnailParser() {
        guard let json = json else {
            XCTFail()
            return
        }

        let thumbnails = ThumbnailParser.parseThumbnails(json: json)
        XCTAssertFalse(thumbnails.isEmpty)
        XCTAssertEqual(1, thumbnails.count)

        let thumbnail = thumbnails.first
        XCTAssertNotNil(thumbnail)
        XCTAssertEqual("33976528863", thumbnail!.id)
        XCTAssertEqual("Hello.Moray", thumbnail!.title)
        XCTAssertEqual("https://farm5.staticflickr.com/4274/33976528863_dc5a2e82cf_t.jpg", thumbnail!.thumbnailSizeUrl!.absoluteString)
        XCTAssertEqual("https://farm5.staticflickr.com/4274/33976528863_dc5a2e82cf_h.jpg", thumbnail!.url!.absoluteString)
        XCTAssertEqual(234, thumbnail!.height)
        XCTAssertEqual(240, thumbnail!.width)
    }
}
