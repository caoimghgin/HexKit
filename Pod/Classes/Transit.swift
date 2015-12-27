//
//  Transit.swift
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

class Transit {
    
    enum State : Int {
        case Allowed
        case InsufficiantMovementPoints
        case MaximumMovementReached
        case Unexpected
    }
    
    var unit = Unit()
    var departing = Tile()
    var itinerary = [Tile]()
    var moves = 0
    
    var path = CGPathCreateMutable()
    var line = CAShapeLayer.init()
    
    internal init() {}
    
    internal init(tile:Tile) {
        
        self.unit = tile.units.first!
        self.unit.superview!.bringSubviewToFront(self.unit)
        self.moves = self.unit.movementRemaining
        
        line.fillColor = UIColor.clearColor().CGColor
        line.strokeColor = UIColor.redColor().CGColor
        line.opacity = 0.8
        line.lineWidth = 18
        line.lineJoin = kCALineJoinRound
        line.lineCap = kCALineCapRound
        
        self.departing = tile
        
        self.transit(tile)
    }
    
    internal func departure(departing:Tile) {
        self.departing = departing
    }
    
    internal func transit(tile:Tile) -> State {
        
        if (!itinerary.contains(tile)) && (moves > 0) {
            
            self.itinerary.append(tile)
            
            CGPathMoveToPoint(path, nil, CGFloat(departing.center.x), CGFloat(departing.center.y))
            
            for foo in itinerary {
                CGPathAddLineToPoint(path, nil, CGFloat(foo.center.x), CGFloat(foo.center.y))
                line.path = path
            }
            
            if (tile !== self.departing) {self.moves--}
                        
            return State.Allowed
            
        } else if (itinerary.contains(tile)) {
            
            if (itinerary.last !== tile) {
                
                itinerary.removeLast()
                self.moves++
                
                path = CGPathCreateMutable()
                
                var index = 0
                for foo in itinerary {
                    if (index == 0) {
                        path = CGPathCreateMutable()
                        CGPathMoveToPoint(path, nil, CGFloat(foo.center.x), CGFloat(foo.center.y))
                    } else {
                        CGPathAddLineToPoint(path, nil, CGFloat(foo.center.x), CGFloat(foo.center.y))
                    }
                    line.path = path
                    index++
                }
            }
            
            return State.Unexpected
            
        } else if (tile === self.departing) {
            print("CONTAINS DEPARTING HEX")
            return State.Unexpected
            
        } else if !(moves > 0) {
            print("Count move error HEX")
            return State.Unexpected
            
        } else {
            
            return State.Unexpected
            
        }
        
    }
    
    internal func arrival(arriving:Tile) {
        self.itinerary.append(arriving)
    }
    
    func end() {
        path = CGPathCreateMutable()
        line.path = path
    }
    
}
