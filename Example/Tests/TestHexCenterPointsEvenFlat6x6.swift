//
//  TestHexCenterPointsEvenFlat6x6.swift
//  HexKit
//
//  Copyright © 2015 Kevin Muldoon.
//  https://github.com/caoimghgin/HexKit
//

import UIKit
import XCTest
import HexKit

class TestHexCenterPointsEvenFlat6x6: XCTestCase {
    
    let width = 6
    let height = 6
    let gridShape = Grid.Shape.Even
    let tileShape = Tile.Shape.FlatTopped
    let tileRadius = 22.0
    
    let accuracy : Double = 0.000000000001
    
    override func setUp() {
        super.setUp()

        HexKit.sharedInstance.start(
            Grid.Size(width : width, height : height),
            gridShape: gridShape,
            tileShape: tileShape,
            tileRadius: tileRadius
        )
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_Q0() {
        
        let q : Int = 1
        var tile : Tile!
                
        tile = HexKit.sharedInstance.tile(q:q, r:0)
        XCTAssertEqualWithAccuracy (tile.center.x, 22.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 38.1051177665153, accuracy: accuracy, "Expected result not equal");
        
        tile = HexKit.sharedInstance.tile(q:q, r:1)
        XCTAssertEqualWithAccuracy (tile.center.x, 22.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 76.2102355330306, accuracy: accuracy, "Expected result not equal");
        
        tile = HexKit.sharedInstance.tile(q:q, r:2)
        XCTAssertEqualWithAccuracy (tile.center.x, 22.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 114.315353299546, accuracy: accuracy, "Expected result not equal");
        
        tile = HexKit.sharedInstance.tile(q:q, r:3)
        XCTAssertEqualWithAccuracy (tile.center.x, 22.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 152.420471066061, accuracy: accuracy, "Expected result not equal");
        
        tile = HexKit.sharedInstance.tile(q:q, r:4)
        XCTAssertEqualWithAccuracy (tile.center.x, 22.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 190.525588832576, accuracy: accuracy, "Expected result not equal");
        
        tile = HexKit.sharedInstance.tile(q:q, r:5)
        XCTAssertEqualWithAccuracy (tile.center.x, 22.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 228.630706599092, accuracy: accuracy, "Expected result not equal");
        
    }
 
    func test_Q1() {
        
        let q : Int = 2
        var tile : Tile!
        
        tile = HexKit.sharedInstance.tile(q:q, r:-1)
        XCTAssertEqualWithAccuracy (tile.center.x, 55.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 19.0525588832576, accuracy: accuracy, "Expected result not equal");
        
        tile = HexKit.sharedInstance.tile(q:q, r:0)
        XCTAssertEqualWithAccuracy (tile.center.x, 55.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 57.157676649773, accuracy: accuracy, "Expected result not equal");
        
        tile = HexKit.sharedInstance.tile(q:q, r:1)
        XCTAssertEqualWithAccuracy (tile.center.x, 55.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 95.2627944162882, accuracy: accuracy, "Expected result not equal");
        
        tile = HexKit.sharedInstance.tile(q:q, r:2)
        XCTAssertEqualWithAccuracy (tile.center.x, 55.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 133.367912182804, accuracy: accuracy, "Expected result not equal");
        
        tile = HexKit.sharedInstance.tile(q:q, r:3)
        XCTAssertEqualWithAccuracy (tile.center.x, 55.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 171.473029949319, accuracy: accuracy, "Expected result not equal");
        
        tile = HexKit.sharedInstance.tile(q:q, r:4)
        XCTAssertEqualWithAccuracy (tile.center.x, 55.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 209.578147715834, accuracy: accuracy, "Expected result not equal");
        
    }

    func test_Q2() {
        
        let q : Int = 3
        var tile : Tile!
        
        tile = HexKit.sharedInstance.tile(q:q, r:-1)
        XCTAssertEqualWithAccuracy (tile.center.x, 88.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 38.1051177665153, accuracy: accuracy, "Expected result not equal");
        
        tile = HexKit.sharedInstance.tile(q:q, r:0)
        XCTAssertEqualWithAccuracy (tile.center.x, 88.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 76.2102355330306, accuracy: accuracy, "Expected result not equal");
        
        tile = HexKit.sharedInstance.tile(q:q, r:1)
        XCTAssertEqualWithAccuracy (tile.center.x, 88.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 114.315353299546, accuracy: accuracy, "Expected result not equal");
        
        tile = HexKit.sharedInstance.tile(q:q, r:2)
        XCTAssertEqualWithAccuracy (tile.center.x, 88.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 152.420471066061, accuracy: accuracy, "Expected result not equal");
        
        tile = HexKit.sharedInstance.tile(q:q, r:3)
        XCTAssertEqualWithAccuracy (tile.center.x, 88.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 190.525588832576, accuracy: accuracy, "Expected result not equal");
        
        tile = HexKit.sharedInstance.tile(q:q, r:4)
        XCTAssertEqualWithAccuracy (tile.center.x, 88.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 228.630706599092, accuracy: accuracy, "Expected result not equal");
        
    }
    
    func test_Q3() {
        
        let q : Int = 4
        var tile : Tile!
        
        tile = HexKit.sharedInstance.tile(q:q, r:-2)
        XCTAssertEqualWithAccuracy (tile.center.x, 121.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 19.0525588832576, accuracy: accuracy, "Expected result not equal");
        
        tile = HexKit.sharedInstance.tile(q:q, r:-1)
        XCTAssertEqualWithAccuracy (tile.center.x, 121.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 57.157676649773, accuracy: accuracy, "Expected result not equal");
        
        tile = HexKit.sharedInstance.tile(q:q, r:0)
        XCTAssertEqualWithAccuracy (tile.center.x, 121.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 95.2627944162882, accuracy: accuracy, "Expected result not equal");
        
        tile = HexKit.sharedInstance.tile(q:q, r:1)
        XCTAssertEqualWithAccuracy (tile.center.x, 121.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 133.367912182804, accuracy: accuracy, "Expected result not equal");
        
        tile = HexKit.sharedInstance.tile(q:q, r:2)
        XCTAssertEqualWithAccuracy (tile.center.x, 121.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 171.473029949319, accuracy: accuracy, "Expected result not equal");
        
        tile = HexKit.sharedInstance.tile(q:q, r:3)
        XCTAssertEqualWithAccuracy (tile.center.x, 121.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 209.578147715834, accuracy: accuracy, "Expected result not equal");
        
    }
    
    func test_Q4() {
        
        let q : Int = 5
        var tile : Tile!
        
        tile = HexKit.sharedInstance.tile(q:q, r:-2)
        XCTAssertEqualWithAccuracy (tile.center.x, 154.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 38.1051177665153, accuracy: accuracy, "Expected result not equal");
        
        tile = HexKit.sharedInstance.tile(q:q, r:-1)
        XCTAssertEqualWithAccuracy (tile.center.x, 154.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 76.2102355330306, accuracy: accuracy, "Expected result not equal");
        
        tile = HexKit.sharedInstance.tile(q:q, r:0)
        XCTAssertEqualWithAccuracy (tile.center.x, 154.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 114.315353299546, accuracy: accuracy, "Expected result not equal");
        
        tile = HexKit.sharedInstance.tile(q:q, r:1)
        XCTAssertEqualWithAccuracy (tile.center.x, 154.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 152.420471066061, accuracy: accuracy, "Expected result not equal");
        
        tile = HexKit.sharedInstance.tile(q:q, r:2)
        XCTAssertEqualWithAccuracy (tile.center.x, 154.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 190.525588832576, accuracy: accuracy, "Expected result not equal");
        
        tile = HexKit.sharedInstance.tile(q:q, r:3)
        XCTAssertEqualWithAccuracy (tile.center.x, 154.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 228.630706599092, accuracy: accuracy, "Expected result not equal");
        
    }
    
    func test_Q5() {
        
        let q : Int = 6
        var tile : Tile!
        
        tile = HexKit.sharedInstance.tile(q:q, r:-3)
        XCTAssertEqualWithAccuracy (tile.center.x, 187.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 19.0525588832576, accuracy: accuracy, "Expected result not equal");
        
        tile = HexKit.sharedInstance.tile(q:q, r:-2)
        XCTAssertEqualWithAccuracy (tile.center.x, 187.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 57.157676649773, accuracy: accuracy, "Expected result not equal");
        
        tile = HexKit.sharedInstance.tile(q:q, r:-1)
        XCTAssertEqualWithAccuracy (tile.center.x, 187.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 95.2627944162882, accuracy: accuracy, "Expected result not equal");
        
        tile = HexKit.sharedInstance.tile(q:q, r:0)
        XCTAssertEqualWithAccuracy (tile.center.x, 187.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 133.367912182804, accuracy: accuracy, "Expected result not equal");
        
        tile = HexKit.sharedInstance.tile(q:q, r:1)
        XCTAssertEqualWithAccuracy (tile.center.x, 187.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 171.473029949319, accuracy: accuracy, "Expected result not equal");
        
        tile = HexKit.sharedInstance.tile(q:q, r:2)
        XCTAssertEqualWithAccuracy (tile.center.x, 187.0, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, 209.578147715834, accuracy: accuracy, "Expected result not equal");
        
    }
}
