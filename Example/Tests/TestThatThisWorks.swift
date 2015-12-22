//
//  TestThatThisWorks.swift
//  HexKit
//
//  Created by Kevin Muldoon on 12/21/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import XCTest

class TestThatThisWorks: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(1==42)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
