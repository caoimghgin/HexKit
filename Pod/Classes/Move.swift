//
//  Move.swift
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

class Move {
    
    var transit : Transit!
    var context: Int = 0
    
    init(transit:Transit) {
        self.transit = transit
        move()
    }
    
    func hostileHexesInTransit(arriving:Tile, departing:Tile) -> Set<Tile> {
        
        var occupiedNeighbors = Set<Tile>()
        let hexes = arriving.neighbors() + departing.neighbors()
        for hex in hexes {
            if (hex.units.count > 0) {
                if (self.transit.unit.alliance != hex.units.first?.alliance) {
                    occupiedNeighbors.insert(hex)
                }
            }
        }
        return occupiedNeighbors;
    }
    
    func move() {
        
        if self.transit.itinerary.count < 2 {return}
        
        let departingHex = self.transit.itinerary[self.context]
        let arrivingHex = self.transit.itinerary[self.context+1]
        let occupiedNeighbors = self.hostileHexesInTransit(arrivingHex, departing: departingHex)
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            
            self.transit.unit.center = CGPoint(x: CGFloat(arrivingHex.center.x), y: CGFloat(arrivingHex.center.y))
            
            }, completion: {_ in
                
                departingHex.removeUnit(self.transit.unit)
                arrivingHex.addUnit(self.transit.unit)
                arrivingHex.sendUnitToFront(self.transit.unit)
                self.transit.unit.movementRemaining--
                self.context++
                
                for tile in occupiedNeighbors {
                    tile.unitsVisible(tile.hostileNeighbors())
                }
                
                if (self.context+2 <= self.transit.itinerary.count) {
                    
                    if arrivingHex.hostileNeighbors() == false {
                        self.move()
                    }
                    
                } else {
                    
                    Move.prettyStack(self.transit.itinerary.last!)
                    Move.prettyStack(self.transit.itinerary.first!)
                    self.transit.itinerary = [Tile]()
                    
                }
        })
        
    }
    
    class func prettyStack(tile:Tile) {
        
        if (tile.units.count == 1) {
            let a = tile.units.first
            
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                a?.center = CGPointMake(CGFloat((tile.center.x)!), CGFloat((tile.center.y)!))
                
                }, completion: {_ in
                    
            })
            
        } else {
            
            let a = tile.units.first
            let b = tile.units.last
            
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                
                if (tile.units.count == 3) {
                    let c = tile.units[1]
                    c.center = CGPointMake(CGFloat((tile.center.x)!), CGFloat((tile.center.y)!))
                    a?.center = CGPointMake(CGFloat((tile.center.x)!) + 6, CGFloat((tile.center.y)!) - 6)
                    b?.center = CGPointMake(CGFloat((tile.center.x)!) - 6, CGFloat((tile.center.y)!) + 6)
                } else {
                    a?.center = CGPointMake(CGFloat((tile.center.x)!) + 4, CGFloat((tile.center.y)!) - 4)
                    b?.center = CGPointMake(CGFloat((tile.center.x)!) - 4, CGFloat((tile.center.y)!) + 4)
                }
            })
            
        }
    }
    
}
