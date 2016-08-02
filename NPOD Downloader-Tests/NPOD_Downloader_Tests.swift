//
//  NPOD_Downloader_Tests.swift
//  NPOD Downloader-Tests
//
//  Created by Giulio Lombardo on 01/08/16.
//  Copyright © 2016 Giulio Lombardo. All rights reserved.
//

import XCTest

class NPOD_Downloader_Tests: XCTestCase {
	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}

	func testUbernodes() {
		let expectation: XCTestExpectation = expectationWithDescription("getUbernodes")

		GrandNetworkDispatch.getUbernodes({
			(ubernodes) in

			XCTAssertGreaterThan(ubernodes.count, 0, "The ubernodes number must be greater than 0")

			expectation.fulfill()
			}, failure: {
				(errorData) in

				XCTFail(errorData as! String)
		})
		
		waitForExpectationsWithTimeout(60) {
			(error) in

			guard error == nil else {
				XCTFail(error!.description)
				return
			}
		}
	}

	func testPerformanceExample() {
		// This is an example of a performance test case.
		self.measureBlock {
			// Put the code you want to measure the time of here.
		}
	}
}