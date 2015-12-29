//
//  HexKit.swift
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

public class HexKit
{
    public static let sharedInstance = HexKit()
    
    var tiles : [String: Tile] = [:]
    var gridSize : Grid.Size
    var gridShape : Grid.Shape
    var tileShape : Tile.Shape!
    var gridTileShape : GridTileShape
    var tileSize : Size
    var tileOffset : Point
    var hexRadius : Double
    var firstColumn: [Int] = []
    let directions = [
        Cube(x:0, y:1, z:-1),
        Cube(x:1, y:0, z:-1),
        Cube(x:1, y:-1, z:0),
        Cube(x:0, y:-1, z:1),
        Cube(x:-1, y:0, z:1),
        Cube(x:-1, y:1, z:0)
    ]
    
    var turn = Unit.Alliance.Blue
    
    enum GridTileShape : Int {
        
        case OddFlat
        case EvenFlat
        case OddPoint
        case EvenPoint
        
        static func shape(gridShape gridShape : Grid.Shape, hexShape : Tile.Shape) -> GridTileShape  {
            
            if (gridShape == Grid.Shape.Odd && hexShape == Tile.Shape.FlatTopped) {
                return GridTileShape.OddFlat
            } else if (gridShape == Grid.Shape.Odd && hexShape == Tile.Shape.PointTopped) {
                return GridTileShape.OddPoint
            } else if (gridShape == Grid.Shape.Even && hexShape == Tile.Shape.FlatTopped) {
                return GridTileShape.EvenFlat
            } else {
                return GridTileShape.EvenPoint
            }
        }
    }
    
    private convenience init() {
        self.init(
            gridSize: Grid.Size(width : 22, height : 22),
            gridShape: Grid.Shape.Even,
            hexShape: Tile.Shape.PointTopped,
            hexRadius: 44.0
        )
    }
    
    public init(gridSize : Grid.Size, gridShape : Grid.Shape, hexShape: Tile.Shape, hexRadius:Double) {
        
        self.gridSize = gridSize
        self.gridShape = gridShape
        self.tileShape = hexShape
        self.hexRadius = hexRadius
        
        self.tileSize = hexTileSize(hexRadius, type: hexShape)
        self.tileOffset = offsetForHex(hexShape, size: tileSize)
        self.gridTileShape = GridTileShape.shape(gridShape : gridShape, hexShape : hexShape)
        self.firstColumn = createFirstColumn(gridSize.width)
        
    }
    
    public func start() {
        self.start(
            Grid.Size(width : 50, height : 50),
            gridShape: Grid.Shape.Odd,
            tileShape: Tile.Shape.FlatTopped,
            tileRadius: 44.0
        )
    }
    
    public func start(fileName : String) {
        
        if let parameters = Dictionary<String, AnyObject>.loadProperties(fileName) {
            
            let width = parameters["Grid Size"]![0].integerValue
            let height = parameters["Grid Size"]![1].integerValue
            let gridShape = ((parameters["Grid Shape"] as! String) == "Odd" ? Grid.Shape.Odd : Grid.Shape.Even)
            let tileShape = ((parameters["Tile Shape"] as! String) == "FlatTopped" ? Tile.Shape.FlatTopped : Tile.Shape.PointTopped)
            let tileRadius = (parameters["Tile Radius"] as! Double)
            
            self.start(
                
                Grid.Size(width : width, height : height),
                gridShape: gridShape,
                tileShape: tileShape,
                tileRadius: tileRadius
                
            )
            
        }
        
    }
    
    public func start(gridSize : Grid.Size, gridShape : Grid.Shape, tileShape: Tile.Shape, tileRadius:Double) {
        
        self.gridSize = gridSize
        self.gridShape = gridShape
        self.tileShape = tileShape
        self.hexRadius = tileRadius
        
        tileSize = hexTileSize(tileRadius, type: tileShape)
        tileOffset = offsetForHex(tileShape, size: tileSize)
        gridTileShape = GridTileShape.shape(gridShape : gridShape, hexShape : tileShape)
        firstColumn = createFirstColumn(gridSize.width)
        createHexes()
    }
    
    private func createHexes() {
        
        if (tileShape == Tile.Shape.FlatTopped) {
            
            tiles = layoutFlatTopped()
            
        } else if (tileShape == Tile.Shape.PointTopped) {
            
            tiles = layoutPointTopped()
            
        } else {
            
            assertionFailure("GridHexShape.shape is invalid value")
            
        }
        
    }
    
    private func layoutPointTopped() -> [String: Tile] {
        
        if self.gridTileShape == GridTileShape.EvenPoint {
            return layoutGridShapeEvenPoint()
        } else {
            return layoutGridShapeOddPoint()
        }
        
    }
    
    private func layoutGridShapeOddPoint() -> [String: Tile] {
        
        let offset = offsetsForGridHexShape()
        
        var result = [String: Tile]()
        let origin = offset.origin
        var center = origin
        
        var yOffset = 0
        var table: [[Cube]] = []
        for (var r = 0; r < gridSize.height; ++r) {
            
            var row : [Cube] = []
            
            for (var q = 0; q < gridSize.width; ++q) {
                
                var x : Int
                var y : Int
                var z : Int
                
                if (table.count == 0) {
                    
                    x = q
                    z = r
                    y = -q
                    
                } else {
                    
                    z = r
                    y = yOffset - q
                    x = -z + -y
                    
                }
                
                row.append(Cube(x: x, y: y, z: z))
                
                if (r + q > 0) {
                    center = Point(x: center.x + tileSize.width, y: center.y )
                }
                
                let tile = Tile(
                    cube: Cube(x: x, y: y, z: z),
                    center: center,
                    size: tileSize,
                    shape : self.tileShape,
                    radius: self.hexRadius
                )
                
                result[tile.keyValue] = tile
                
            }
            
            if (r%2 == 0) {yOffset--}
            table.append(row)
            
            var rx = 0.0
            if (((r + 1) % 2) == 0) {rx = offset.outer[0]} else {rx = offset.outer[1]}
            center = Point(x: origin.x - (tileSize.width * rx), y: center.y + (tileSize.height * 0.75))
            
        }
        
        return result
        
    }
    
    private func layoutGridShapeEvenPoint() -> [String: Tile] {
        
        let offset = offsetsForGridHexShape()
        
        var result = [String: Tile]()
        let origin = offset.origin
        var center = origin
        
        var xOffset = 0
        var table: [[Cube]] = []
        for (var r = 0; r < gridSize.height; ++r) {
            
            var row : [Cube] = []
            
            for (var q = 0; q < gridSize.width; ++q) {
                
                var x : Int
                var y : Int
                var z : Int
                
                if (table.count == 0) {
                    
                    x = q
                    z = r
                    y = -q
                    
                } else {
                    
                    z = r
                    x = xOffset + q
                    y = -(x+z)
                    
                }
                
                row.append(Cube(x: x, y: y, z: z))
                
                
                if (r + q > 0) {
                    center = Point(x: center.x + tileSize.width, y: center.y )
                }
                
                let tile = Tile(
                    cube: Cube(x: x, y: y, z: z),
                    center: center,
                    size: tileSize,
                    shape : self.tileShape,
                    radius: self.hexRadius
                )
                
                result[tile.keyValue] = tile
                
            }
            
            if (r%2 == 0) {xOffset--}
            table.append(row)
            
            var rx = 0.0
            if (((r + 1) % 2) == 0) {rx = offset.outer[0]} else {rx = offset.outer[1]}
            center = Point(x: origin.x - (tileSize.width * rx), y: center.y + (tileSize.height * 0.75))
            
        }
        
        return result
        
    }
    
    private func layoutGridShapeOddFlat() -> [String: Tile]  {
        
        let offset = offsetsForGridHexShape()
        
        var result = [String: Tile]()
        let origin = offset.origin
        var center = origin
        
        var table: [[Cube]] = []
        
        for (var r = 0; r < gridSize.height; ++r) {
            
            var row : [Cube] = []
            
            for (var q = 0; q < gridSize.width; ++q) {
                
                var x : Int
                var y : Int
                var z : Int
                
                if (table.count == 0) {
                    
                    x = q
                    z = -Int(floor(Double(q)/2))
                    y = -Int(ceil(Double(q)/2))
                    
                } else {
                    x = table[r-1][q].x
                    z = table[r-1][q].z+1
                    y = -(x+z)
                }
                
                row.append(Cube(x: x, y: y, z: z))
                
                if (r + q > 0) {
                    let x = offset.inner.x
                    var y = offset.inner.y
                    if (((q + 1) % 2) == 1) { y = -y }
                    center += Point(x : x, y : y)
                }
                
                let tile = Tile(
                    cube: Cube(x: x, y: y, z: z),
                    center: center,
                    size: tileSize,
                    shape : self.tileShape,
                    radius: self.hexRadius
                )
                
                result[tile.keyValue] = tile
                
            }
            
            table.append(row)
            
            var rx : Double
            if (gridSize.width % 2 == 0) {rx = offset.outer[0]} else {rx = offset.outer[1]}
            center = Point(x: origin.x - (tileSize.width * 0.75) , y: center.y + (tileSize.height * rx))
            
        }
        
        return result
        
    }
    
    private func layoutGridShapeEvenFlat() -> [String: Tile]  {
        
        let offset = offsetsForGridHexShape()
        
        var result = [String: Tile]()
        let origin = offset.origin
        var center = origin
        
        var table: [[Cube]] = []
        
        for (var r = 0; r < gridSize.height; ++r) {
            
            var row : [Cube] = []
            
            for (var q = 0; q < gridSize.width; ++q) {
                
                var x : Int
                var y : Int
                var z : Int
                
                if (table.count == 0) {
                    
                    if (((q + 1) % 2) == 0) {
                        x = q+1
                        z = -Int(floor(Double(q)/2)) - 1
                        y = -Int(ceil(Double(q)/2)) - 1
                    } else {
                        x = q+1
                        z = -Int(floor(Double(q)/2))
                        y = -Int(ceil(Double(q)/2))
                    }
                    
                    
                } else {
                    x = table[r-1][q].x
                    z = table[r-1][q].z+1
                    y = -(x+z)
                }
                
                row.append(Cube(x: x, y: y, z: z))
                
                if (r + q > 0) {
                    let x = offset.inner.x
                    var y = offset.inner.y
                    if (((q + 1) % 2) == 1) { y = -y }
                    center += Point(x : x, y : y)
                }
                
                let tile = Tile(
                    cube: Cube(x: x, y: y, z: z),
                    center: center,
                    size: tileSize,
                    shape : self.tileShape,
                    radius: self.hexRadius
                )
                
                result[tile.keyValue] = tile
                
            }
            
            table.append(row)
            
            var rx : Double
            if (gridSize.width % 2 == 0) {rx = offset.outer[0]} else {rx = offset.outer[1]}
            center = Point(x: origin.x - (tileSize.width * 0.75) , y: center.y + (tileSize.height * rx))
            
        }
        
        return result
        
    }
    
    private func layoutFlatTopped() -> [String: Tile]  {
        
        if self.gridTileShape == GridTileShape.EvenFlat {
            return layoutGridShapeEvenFlat()
        } else {
            return layoutGridShapeOddFlat()
        }
        
    }
    
    private func createFirstColumn(rows : Int) -> [Int]  {
        var result: [Int] = []
        for (var r = 0; r < rows; ++r) {
            result.append( Int(-floor(Double(r)/2)) )
        }
        return result
    }
    
    private func axialOffset(r : Int) -> Int {
        if (r < firstColumn.count) { return firstColumn[r] } else { return firstColumn.last!}
    }
    
    private func offsetsForGridHexShape() -> (origin : Point, inner : Point, outer : [Double]) {
        
        var origin : Point!
        var inner : Point!
        var outer : [Double] = []
        
        switch GridTileShape.shape(gridShape : gridShape, hexShape : tileShape) {
            
        case GridTileShape.OddFlat:
            
            origin = Point(x : tileSize.width/2, y : tileSize.height/2)
            inner = tileOffset
            outer = [1.0, 1.5]
            
        case GridTileShape.EvenFlat:
            
            origin = Point(x : tileSize.width/2, y : tileSize.height)
            inner = Point(x: tileOffset.x, y: -tileOffset.y)
            outer = [1.0, 0.5]
            
        case GridTileShape.OddPoint:
            
            origin = Point(x : tileSize.width/2, y : tileSize.height/2)
            inner = tileOffset
            outer = [1.0, 0.5]
            
        case GridTileShape.EvenPoint:
            
            origin = Point(x : tileSize.width, y : tileSize.height/2)
            inner = tileOffset
            outer = [1.0, 1.5]
            
        }
        
        return (origin, inner, outer)
        
    }
    
    public func tile() -> Tile? {
        
        return self.tiles.values.first!
        
    }
    
    public func tile(q q:Int, r:Int) -> Tile? {
        
        return tiles[Tile.keyFormat(q: q, r: r)]
        
    }
    
    public func tile(hex:Hex) -> Tile? {
        
        return tile(q: hex.q, r: hex.r)
        
    }
    
    public func distance(a:Tile, b:Tile) -> Int {
        return max(abs(a.cube.x - b.cube.x), abs(a.cube.y - b.cube.y), abs(a.cube.z - b.cube.z))
    }
    
    public func neighbors(tile:Tile) -> [Tile] {
        
        var result: [Tile] = []
        
        let directions = [
            Hex.Convert(self.directions[0]),
            Hex.Convert(self.directions[1]),
            Hex.Convert(self.directions[2]),
            Hex.Convert(self.directions[3]),
            Hex.Convert(self.directions[4]),
            Hex.Convert(self.directions[5])
        ]
        
        for point in directions {
            
            let tile = self.tile(q: tile.hex.q + point.q, r: tile.hex.r + point.r)
            if (tile != nil) { result.append((tile)!)}
            
        }
        return result;
    }
    
}