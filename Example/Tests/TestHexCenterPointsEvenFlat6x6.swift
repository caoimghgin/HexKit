//
//  TestHexCenterPointsEvenFlat6x6.swift
//  HexKit
//
//  Created by Kevin Muldoon on 8/17/15.
//  Copyright (c) 2015 RobotJackalope. All rights reserved.
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

        tile = HexKit.sharedInstance.tile(q:q, r:0);
        assertTileCenterAtXY(tile, 22.0, 38.1051177665153);

        tile = HexKit.sharedInstance.tile(q:q, r:1);
        assertTileCenterAtXY(tile, 22.0, 76.2102355330306);

        tile = HexKit.sharedInstance.tile(q:q, r:2);
        assertTileCenterAtXY(tile, 22.0, 114.315353299546);

        tile = HexKit.sharedInstance.tile(q:q, r:3);
        assertTileCenterAtXY(tile, 22.0, 152.420471066061);

        tile = HexKit.sharedInstance.tile(q:q, r:4);
        assertTileCenterAtXY(tile, 22.0, 190.525588832576);

        tile = HexKit.sharedInstance.tile(q:q, r:5);
        assertTileCenterAtXY(tile, 22.0, 228.630706599092);

    }

    func test_Q1() {

        let q : Int = 2
        var tile : Tile!

        tile = HexKit.sharedInstance.tile(q:q, r:-1)
        assertTileCenterAtXY(tile, 55.0, 19.0525588832576);

        tile = HexKit.sharedInstance.tile(q:q, r:0)
        assertTileCenterAtXY(tile, 55.0, 57.157676649773);

        tile = HexKit.sharedInstance.tile(q:q, r:1)
        assertTileCenterAtXY(tile, 55.0, 95.2627944162882);

        tile = HexKit.sharedInstance.tile(q:q, r:2)
        assertTileCenterAtXY(tile, 55.0, 133.367912182804);

        tile = HexKit.sharedInstance.tile(q:q, r:3)
        assertTileCenterAtXY(tile, 55.0, 171.473029949319);

        tile = HexKit.sharedInstance.tile(q:q, r:4)
        assertTileCenterAtXY(tile, 55.0, 209.578147715834);

    }

    func test_Q2() {

        let q : Int = 3
        var tile : Tile!

        tile = HexKit.sharedInstance.tile(q:q, r:-1)
        assertTileCenterAtXY(tile, 88.0, 38.1051177665153);

        tile = HexKit.sharedInstance.tile(q:q, r:0)
        assertTileCenterAtXY(tile, 88.0, 76.2102355330306);

        tile = HexKit.sharedInstance.tile(q:q, r:1)
        assertTileCenterAtXY(tile, 88.0, 114.315353299546);

        tile = HexKit.sharedInstance.tile(q:q, r:2)
        assertTileCenterAtXY(tile, 88.0, 152.420471066061);

        tile = HexKit.sharedInstance.tile(q:q, r:3)
        assertTileCenterAtXY(tile, 88.0, 190.525588832576);

        tile = HexKit.sharedInstance.tile(q:q, r:4)
        assertTileCenterAtXY(tile, 88.0, 228.630706599092);

    }

    func test_Q3() {

        let q : Int = 4
        var tile : Tile!

        tile = HexKit.sharedInstance.tile(q:q, r:-2)
        assertTileCenterAtXY(tile, 121.0, 19.0525588832576);

        tile = HexKit.sharedInstance.tile(q:q, r:-1)
        assertTileCenterAtXY(tile, 121.0, 57.157676649773);

        tile = HexKit.sharedInstance.tile(q:q, r:0)
        assertTileCenterAtXY(tile, 121.0, 95.2627944162882);

        tile = HexKit.sharedInstance.tile(q:q, r:1)
        assertTileCenterAtXY(tile, 121.0, 133.367912182804);

        tile = HexKit.sharedInstance.tile(q:q, r:2)
        assertTileCenterAtXY(tile, 121.0, 171.473029949319);

        tile = HexKit.sharedInstance.tile(q:q, r:3)
        assertTileCenterAtXY(tile, 121.0, 209.578147715834);

    }

    func test_Q4() {

        let q : Int = 5
        var tile : Tile!

        tile = HexKit.sharedInstance.tile(q:q, r:-2)
        assertTileCenterAtXY(tile, 154.0, 38.1051177665153);

        tile = HexKit.sharedInstance.tile(q:q, r:-1)
        assertTileCenterAtXY(tile, 154.0, 76.2102355330306);

        tile = HexKit.sharedInstance.tile(q:q, r:0)
        assertTileCenterAtXY(tile, 154.0, 114.315353299546);

        tile = HexKit.sharedInstance.tile(q:q, r:1)
        assertTileCenterAtXY(tile, 154.0, 152.420471066061);

        tile = HexKit.sharedInstance.tile(q:q, r:2)
        assertTileCenterAtXY(tile, 154.0, 190.525588832576);

        tile = HexKit.sharedInstance.tile(q:q, r:3)
        assertTileCenterAtXY(tile, 154.0, 228.630706599092);

    }

    func test_Q5() {

        let q : Int = 6
        var tile : Tile!

        tile = HexKit.sharedInstance.tile(q:q, r:-3)
        assertTileCenterAtXY(tile, 187.0, 19.0525588832576);

        tile = HexKit.sharedInstance.tile(q:q, r:-2)
        assertTileCenterAtXY(tile, 187.0, 57.157676649773);

        tile = HexKit.sharedInstance.tile(q:q, r:-1)
        assertTileCenterAtXY(tile, 187.0, 95.2627944162882);

        tile = HexKit.sharedInstance.tile(q:q, r:0)
        assertTileCenterAtXY(tile, 187.0, 133.367912182804);

        tile = HexKit.sharedInstance.tile(q:q, r:1)
        assertTileCenterAtXY(tile, 187.0, 171.473029949319);

        tile = HexKit.sharedInstance.tile(q:q, r:2)
        assertTileCenterAtXY(tile, 187.0, 209.578147715834);

    }

    func assertTileCenterAtXY(tile, x, y) {

        XCTAssertEqualWithAccuracy (tile.center.x, x, accuracy: accuracy, "Expected result not equal");
        XCTAssertEqualWithAccuracy (tile.center.y, y, accuracy: accuracy, "Expected result not equal");

    }
}
