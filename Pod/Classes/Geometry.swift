//
//  Geometry.swift
//  https://github.com/caoimghgin/HexKit
//
//  Copyright © 2015 Kevin Muldoon.
//
//  This code is distributed under the terms and conditions of the MIT license.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

import Foundation
import UIKit

/**
 A structure that contains width and height values.
*/
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

/**
 A two dimensional coordinate system for hex grids, using q (column), r (row) variables.
*/
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

/**
 A three dimensional coordinate system handy for calculating distances and relationships for hex grids.
*/
struct Cube : Equatable {
    
    let x : Int!
    let y : Int!
    let z : Int!
    
    var description: String {
        return "[x:\(x), y:\(y), z:\(z)]"
    }
}
func ==(lhs: Cube, rhs: Cube) -> Bool {
    return (lhs.x == rhs.x) && (lhs.y == rhs.y) && (lhs.z == rhs.z)
}

/**
A two dimensional coordinate system for hex grids.
*/
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

/**
A structure that contains the location and dimensions of a rectangle. The context is flipped-coordinate, origin is upper-left corner and the rectangle extends towards the lower right.
*/
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

/**
A structure that contains a point in a two-dimensional coordinate system.
*/
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

/**
Size of Tile for given radius and hexagon (Tile) shape
 - parameter radius: Double
 - parameter type: Tile.Shape

 - returns: Size
*/
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

/**
 Hexagon offset for given hexagon (Tile) shape and size. Returns center point of Tile for grid construction.
 - parameter shape: Tile.Shape
 - parameter size: Size
 
 - returns: Center point of tile
 */
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
