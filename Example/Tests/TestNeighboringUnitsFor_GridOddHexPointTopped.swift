//
//  TestNeighboringUnitsFor_GridEvenHexPointTopped.swift
//  HexKit
//
//  Copyright © 2015 Kevin Muldoon.
//  https://github.com/caoimghgin/HexKit
//

import XCTest
import  HexKit

class TestNeighboringUnitsFor_GridOddHexPointTopped: XCTestCase {
    
    let width = 50
    let height = 50
    let gridShape = Grid.Shape.Odd
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
    
    func testNeighborsCenter() {
        
        let hex = HexKit.sharedInstance.tile(q: 25, r: 3)
        let neighbors = HexKit.sharedInstance.neighbors(hex!)
                
        XCTAssertTrue(neighbors[0].hex == Hex(q: 24,r: 3))
        XCTAssertTrue(neighbors[1].hex == Hex(q: 24, r: 4))
        XCTAssertTrue(neighbors[2].hex == Hex(q: 25, r: 4))
        XCTAssertTrue(neighbors[3].hex == Hex(q: 26, r: 3))
        XCTAssertTrue(neighbors[4].hex == Hex(q: 26, r: 2))
        XCTAssertTrue(neighbors[5].hex == Hex(q: 25, r: 2))
        
    }
    
    func testNeighborsBottomRight() {
        
        let hex = HexKit.sharedInstance.tile(q: 25, r: 49)
        let neighbors = HexKit.sharedInstance.neighbors(hex!)
        
        XCTAssertEqual(neighbors.count, 2)
        XCTAssertTrue(neighbors[0].hex == Hex(q: 24, r: 49))
        XCTAssertTrue(neighbors[1].hex == Hex(q: 25, r: 48))

    }
    
    func testNeighborsTopRight() {
        
        let hex = HexKit.sharedInstance.tile(q: 49, r: 0)
        let neighbors = HexKit.sharedInstance.neighbors(hex!)
        
        XCTAssertEqual(neighbors.count, 3)
        XCTAssertTrue(neighbors[0].hex == Hex(q: 48, r: 0))
        XCTAssertTrue(neighbors[1].hex == Hex(q: 48, r: 1))
        XCTAssertTrue(neighbors[2].hex == Hex(q: 49, r: 1))

    }
    
    func testNeighborsTopLeft() {
        
        let hex = HexKit.sharedInstance.tile(q: 0, r: 0)
        let neighbors = HexKit.sharedInstance.neighbors(hex!)
        
        XCTAssertEqual(neighbors.count, 2)
        XCTAssertTrue(neighbors[0].hex == Hex(q: 0, r: 1))
        XCTAssertTrue(neighbors[1].hex == Hex(q: 1, r: 0))
        
    }
    
    func testNeighborsBottomLeft() {
        
        let hex = HexKit.sharedInstance.tile(q: -24, r: 49)
        let neighbors = HexKit.sharedInstance.neighbors(hex!)
        
        XCTAssertEqual(neighbors.count, 3)
        XCTAssertTrue(neighbors[0].hex == Hex(q: -23, r: 49))
        XCTAssertTrue(neighbors[1].hex == Hex(q: -23, r: 48))
        XCTAssertTrue(neighbors[2].hex == Hex(q: -24, r: 48))

    }
    
}
