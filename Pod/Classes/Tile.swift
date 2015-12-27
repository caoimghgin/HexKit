//
//  Tile.swift
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

import UIKit

public func ==(lhs: Tile, rhs: Tile) -> Bool {return lhs.hashValue == rhs.hashValue}
public func <(lhs: Tile, rhs: Tile) -> Bool {return lhs.delta < rhs.delta}
public class Tile: Equatable, Hashable, Comparable, CustomStringConvertible {
    
    public enum Shape : Int {
        case FlatTopped
        case PointTopped
    }

    public var hex : Hex!
    public var center : Point!
    public var hashValue: Int {return "\(self.hex.r),\(self.hex.q)".hashValue}

    var offset : Coord!
    var cube : Cube!
    var size : Size!
    var radius : Double!
    var shape : Shape!
    var delta : Double!
    var units = [Unit]()
    var ø : Double {get {return (self.shape == Tile.Shape.PointTopped ? self.size.width : self.size.height)}}
    var Ø : Double {get {return (self.shape == Tile.Shape.PointTopped ? self.size.height : self.size.width)}}
    var hexCorners : Array<Point> {
        get {
            var result = Array<Point>()
            for var i = 0; i <= 6; ++i {
                let center = Point.zeroPoint()
                let angle_deg = ( (self.shape == Tile.Shape.FlatTopped) ? 60 * Double(i) : 60 * Double(i) + 30 )
                let angle_rad = M_PI / 180 * angle_deg
                let x = Double(center.x) + self.radius * cos(angle_rad);
                let y = Double(center.y) + self.radius * sin(angle_rad);
                
                result.append( Point(x: x + self.center.x, y: y + self.center.y) )
            }
            return result
        }
    }
    var rect : Rect {
        get {
            let origin = Point(x: center.x - (size.width/2), y: center.y - (size.height/2))
            return Rect(origin:origin, size: size)
        }
    }
    var keyValue : String {
        get {
            return Tile.keyFormat(q: self.hex.q, r: self.hex.r)
        }
    }
    public var description: String {return "Tile.\(self.hex) Key:(\(self.keyValue))"}
    
    init () {}
    
    init (cube : Cube, center: Point, size : Size, shape: Shape, radius: Double) {
        
        self.size = size
        self.center = center
        self.shape = shape
        
        self.radius = radius
        self.cube = cube
        self.offset = Coord.Convert(cube)
        self.hex = Hex.Convert(cube)
    }
    
    internal func removeUnit(unit:Unit) {
        units = units.filter() { $0 !== unit }
    }
    
    internal func addUnit(unit:Unit) {
        self.units.insert(unit, atIndex: self.units.count)
    }
    
    internal func sendUnitToBack(unit:Unit) {
        if units.contains(unit) {
            units = units.filter() { $0 !== unit }
            self.units.append(unit)
        }
    }
    
    internal func sendUnitToFront(unit:Unit) {
        if units.contains(unit) {
            units = units.filter() { $0 !== unit }
            self.units.insert(unit, atIndex: 0)
        }
    }
    
    internal func unitsVisible(flag : Bool) {
        var alpha : CGFloat = 0
        if (flag == true) {alpha = 1}
        for unit in units {
            UIView .animateWithDuration(0.35, animations: { () -> Void in
                unit.alpha = alpha
            })
        }
    }
    
    internal func alliance() -> Unit.Alliance {
        if (self.units.count == 0) {
            return Unit.Alliance.Uncontested
        } else {
            let unit = self.units.first
            return (unit?.alliance)!
        }
    }
    
    internal func hostile(alliance : Unit.Alliance) -> Bool {
        return false
    }
    
    internal func hostileNeighbors() -> Bool {

        if (self.alliance() == Unit.Alliance.Uncontested)  {
            return false
        } else {
            for neighbor in self.neighbors() {
                if (neighbor.alliance() != Unit.Alliance.Uncontested && self.alliance() != neighbor.alliance()) {
                    return true
                }
            }
        }
        return false
    }

    public func neighbors() -> [Tile] {
        return HexKit.sharedInstance.neighbors(self)
    }
    
    public func occupyingUnitsDetail() -> String {
        
        var info = ""
        for unit in self.units {
            info = info+"\r"+unit.description
        }
        
        return info
    }
    
    class func keyFormat(q q:Int, r:Int) -> String {
        return String(format: "%03dx%03d", arguments: [q, r])
    }

}