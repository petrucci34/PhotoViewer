//
//  PhotoViewerUITests.swift
//  PhotoViewerUITests
//
//  Created by Bircan, Korhan on 5/17/17.
//  Copyright © 2017 Korhan. All rights reserved.
//

import XCTest

class PhotoViewerUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
    }
    
    func testSearchForFlower() {
        let app = XCUIApplication()
        let enterKeywordsSearchField = app.searchFields["Enter keywords"]
        enterKeywordsSearchField.tap()
        enterKeywordsSearchField.typeText("flower")
        app.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.tap()
        app.otherElements.containing(.navigationBar, identifier:"PhotoViewer.PhotoView").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .scrollView).element.swipeUp()
        XCUIDevice.shared().orientation = .landscapeRight
        XCUIDevice.shared().orientation = .portraitUpsideDown
        XCUIDevice.shared().orientation = .landscapeLeft
        XCUIDevice.shared().orientation = .portrait
        app.navigationBars["PhotoViewer.PhotoView"].buttons["Search Photos"].tap()
        enterKeywordsSearchField.tap()
        enterKeywordsSearchField.buttons["Clear text"].tap()
    }
    
}
