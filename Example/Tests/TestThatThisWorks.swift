//
//  TestThatThisWorks.swift
//  HexKit
//
//  Created by Kevin Muldoon on 12/21/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import XCTest
import HexKit

class TestThatThisWorks: XCTestCase {

    let width = 50
    let height = 50
    let gridShape = Grid.Shape.Even
    let hexShape = Tile.Shape.PointTopped
    let hexRadius = 44.0
    
    var scene : Scene!
    
    override func setUp() {
        super.setUp()
        
        HexKit.sharedInstance.start(
            Grid.Size(width : width, height : height),
            gridShape: gridShape,
            tileShape: hexShape,
            tileRadius: hexRadius
        )
        
        self.scene = Scene(frame: CGRectZero)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(1==1)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }

}
