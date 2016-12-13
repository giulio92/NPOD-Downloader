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
		let expectation: XCTestExpectation = self.expectation(description: "getUbernodes")

		GrandNetworkDispatch.getUbernodes({
			(ubernodes) in

			XCTAssertNotNil(ubernodes, "The ubernode object must not be nil")
			XCTAssertGreaterThan(ubernodes.count, 0, "There must be at least one nodeID inside the ubernodes")

			expectation.fulfill()
			}, failure: {
				(errorData) in

				XCTFail(errorData as! String)
		})
		
		waitForExpectations(timeout: URLSessionConfiguration.default.timeoutIntervalForRequest) {
			(error) in

			guard error == nil else {
				XCTFail(error!.description)
				return
			}
		}
	}

	func testPerformanceExample() {
		// This is an example of a performance test case.
		self.measure {
			// Put the code you want to measure the time of here.
		}
	}
}
