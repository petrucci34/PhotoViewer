//
//  PhotoViewerTests.swift
//  PhotoViewerTests
//
//  Created by Bircan, Korhan on 5/17/17.
//  Copyright © 2017 Korhan. All rights reserved.
//

import XCTest
@testable import PhotoViewer

class PhotoViewerTests: XCTestCase {
    func testTrimRedundantWhitespace() {
        XCTAssertEqual("".trimRedundantWhitespace(), "")
        XCTAssertEqual(" ".trimRedundantWhitespace(), "")
        XCTAssertEqual("   ".trimRedundantWhitespace(), "")
        XCTAssertEqual("hello".trimRedundantWhitespace(), "hello")
        XCTAssertEqual(" hello".trimRedundantWhitespace(), "hello")
        XCTAssertEqual("  hello".trimRedundantWhitespace(), "hello")
        XCTAssertEqual("hello ".trimRedundantWhitespace(), "hello")
        XCTAssertEqual("hello  ".trimRedundantWhitespace(), "hello")
        XCTAssertEqual("  hello  ".trimRedundantWhitespace(), "hello")
        XCTAssertEqual("hello world".trimRedundantWhitespace(), "hello world")
        XCTAssertEqual(" hello  world".trimRedundantWhitespace(), "hello world")
        XCTAssertEqual("  hello   world".trimRedundantWhitespace(), "hello world")
        XCTAssertEqual("  hello   world ".trimRedundantWhitespace(), "hello world")
        XCTAssertEqual("  hello   world   ".trimRedundantWhitespace(), "hello world")
    }
    
}
