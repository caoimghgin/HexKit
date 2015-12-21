//
//  Geometry.swift
//  HexKit
//
//  Created by Kevin Muldoon on 8/10/15.
//  Copyright (c) 2015 RobotJackalope. All rights reserved.
//

import Foundation
import UIKit

struct Size {
    
    let width : Double!
    let height : Double!
    
    static func zeroSize() -> Size {
        return Size(width: 0.0, height: 0.0)
    }
    
    static func CG(size : Size) -> CGSize  {
        return CGSize(width: CGFloat(size.width), height: CGFloat(size.height))
    }
    
    var description: String {
        return "[w:\(width), h:\(height)]"
    }
    
}

public struct Hex : Equatable {
    public let q : Int!
    public let r : Int!
    
    public init(q:Int!, r:Int!)  {
        self.q = q
        self.r = r
    }
    
    static func Convert(cube: Cube) -> Hex {
        return Hex(q: cube.x, r: cube.z)
    }
    
    static func Convert(q q : Double, r : Double ) -> Hex {
        return Hex(q: Int(q), r: Int(r))
    }
    
    var description: String {
        return "[q:\(q), r:\(r)]"
    }
    
}
public func ==(lhs: Hex, rhs: Hex) -> Bool {
    return (lhs.r == rhs.r) && (lhs.q == rhs.q)
}

struct Cube {
    
    let x : Int!
    let y : Int!
    let z : Int!
    
    var description: String {
        return "[x:\(x), y:\(y), z:\(z)]"
    }
}

struct Coord  {
    let x : Int!
    let y : Int!
    
    static func Convert(cube: Cube) -> Coord {
        return Coord(x: cube.x, y: cube.z)
    }
    
    var description: String {
        return "[x:\(x), y:\(y)]"
    }
}

struct Rect {
    let origin : Point!
    let size : Size!
    
    static func CG(rect : Rect) -> CGRect {
        return CGRect(
            x: rect.origin.x,
            y: rect.origin.y,
            width: rect.size.width,
            height: rect.size.height)
    }
}

public struct Point {
    
    public let x : Double!
    public let y : Double!
    
    public init(x :Double!, y:Double!) {
        self.x = x
        self.y = y
    }
    
    static func CG(point : Point) -> CGPoint {
        return CGPoint(x: CGFloat(point.x), y: CGFloat(point.y))
    }
    
    static func CG(point : CGPoint) -> Point {
        return Point(x: Double(point.x), y: Double(point.y))
    }
    
    static func zeroPoint() -> Point {
        return Point(x: 0.0, y: 0.0)
    }
}
func + (left: Point, right: Point) -> Point {
    return Point(x: left.x + right.x, y: left.y + right.y)
}
func += (inout left: Point, right: Point) {
    left = left + right
}
func - (left: Point, right: Point) -> Point {
    return Point(x: left.x - right.x, y: left.y - right.y)
}
func -= (inout left: Point, right: Point) {
    left = left - right
}

func hexTileSize(radius:Double, type:Tile.Shape) -> Size {
    
    let y = radius * 2
    let x = sqrt(3)/2 * y
    
    if (type == Tile.Shape.FlatTopped) {
        return Size(width: y, height: x)
    } else if (type == Tile.Shape.PointTopped) {
        return Size(width: x, height: y)
    } else {
        return Size.zeroSize()
    }
}

func offsetForHex(shape: Tile.Shape, size : Size) -> Point {

    if (shape == Tile.Shape.FlatTopped) {
        return offsetFlatTopped(size)
    } else {
        return offsetPointTopped(size)
    }
}

func offsetFlatTopped(size : Size) -> Point {
    let y = (sqrt(3)/2 * size.width)/2
    let x = size.width * 0.75
    return Point(x: x, y: y)
}

func offsetPointTopped(size : Size) -> Point {
    let y = size.height * 0.75
    let x = size.width
    return Point(x: x, y: y)
}
