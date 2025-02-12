//
//  ExclusiveOffersUITests.swift
//  shopStop
//
//  Created by Rahul Sharma on 26/01/25.
//


import XCTest

final class ExclusiveOffersUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }

    func testExclusiveOffersViewDisplaysCorrectly() {
          // Wait for Exclusive Offers title to appear (increases timeout for slow loads)
          let exclusiveOffersTitle = app.staticTexts["ExclusiveOffersTitle"]
          XCTAssertTrue(exclusiveOffersTitle.waitForExistence(timeout: 5), "Exclusive Offers section should be visible")

          // Scroll down to load Exclusive Offers section
          let scrollView = app.scrollViews.firstMatch
          scrollView.swipeUp()

          // Find the first product image in Exclusive Offers (ensure correct identifier)
        /*  let firstProductThumbnail = app.images["ProductThumbnail_1"]
          XCTAssertTrue(firstProductThumbnail.waitForExistence(timeout: 5), "No products are available in Exclusive Offers")

          // Tap the first product and navigate to ProductView
          firstProductThumbnail.tap()

          // Wait for navigation to Product Details page
          let productDetailsTitle = app.staticTexts["Product Details"]
          XCTAssertTrue(productDetailsTitle.waitForExistence(timeout: 5), "Navigating to ProductView failed")*/
      }
}
