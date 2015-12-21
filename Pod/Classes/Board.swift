//
//  Board.swift
//  HexKit
//
//  Created by Kevin Muldoon on 11/8/15.
//  Copyright © 2015 RobotJackalope. All rights reserved.
//

import Foundation
import UIKit

class Board : UIView, UIGestureRecognizerDelegate {
    
    var artwork = Artwork()
    var arena = Arena()
    var grid = Grid()
    var transit = Transit()
    
    init() {
        
        super.init(frame: grid.frame)
        
        addSubview(artwork)
        addSubview(grid)
        addSubview(arena)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: "panGestureRecognizerAction:")
        panGesture.delegate = self
        self.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapGestureRecognizerAction:")
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
        
    }
    
    override func drawRect(rect: CGRect) {
        
    }
    
    func tapGestureRecognizerAction(gesture : UITapGestureRecognizer) {
    
        let tile = Touch.tile(gesture) ; print(tile)
        
        if (tile.units.count > 1) {
            let unit = tile.units.first
            unit!.superview!.sendSubviewToBack(unit!)
            
            tile.sendUnitToBack(unit!)
            Move.prettyStack(tile)
        }
        
    }
    
    func panGestureRecognizerAction(gesture : UIPanGestureRecognizer) {
        
        switch gesture.state {
            
        case UIGestureRecognizerState.Possible:
            
            print("Possible")
            
        case UIGestureRecognizerState.Began:
            
            let tile = Touch.tile(gesture)
            
            if (tile.units.count > 0) {
                transit = Transit(tile: tile)
                transit.departure(tile)
            }
            self.layer.addSublayer(transit.line)
            
        case UIGestureRecognizerState.Changed:
            
            let state = transit.transit(Touch.tile(gesture))
            
            switch state {
                
            case Transit.State.Allowed:
                
                print("allowed")
                
            case Transit.State.InsufficiantMovementPoints:
                
                gesture.enabled = false
                print("InsufficiantMovementPoints error")
                
            case Transit.State.MaximumMovementReached:
                
                gesture.enabled = false
                print("MaximumMovementReached error")
                
            case Transit.State.Unexpected:
                
                print("Transit.State.Unexpected")
                
            }
            
        case UIGestureRecognizerState.Ended:

            let tile = Touch.tile(gesture)
            transit.transit(tile)
            transit.end()
            _ = Move(transit: transit)
            
        case UIGestureRecognizerState.Cancelled:
            
            /*
            move unit back to originating hex and set gesture to enabled
            */
            transit.arrival(transit.departing)
            gesture.enabled = true
            
        case UIGestureRecognizerState.Failed:
            
            print("failed")
            
        }
        
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {

//        return true; /* uncomment to disable UIScrollView scrolling **/
      
        let tile = Touch.tile(touch)
        
        if (tile.units.count > 0) {
            
            let unit = tile.units.first
            
            if (unit?.alliance == HexKit.sharedInstance.turn) {
                return true
            } else {
                return false
            }
            
        }
        
        return false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false;
    }
    
}

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
            
            print("...Allowed")
            
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

class Artwork : UIImageView {
    
}

class Arena: UIView {
    
}

public class Grid : UIView, UIGestureRecognizerDelegate  {
    
    public enum Shape : Int {
        case Odd
        case Even
    }
    
    public struct Size {
        public let width : Int!
        public let height : Int!
        
        public init(width : Int, height: Int) {
            self.width = width
            self.height = height
        }
    }
    
    init() {
        var width : Double!
        var height : Double!
        
        let model = HexKit.sharedInstance
        
        if (model.tileShape == Tile.Shape.FlatTopped) {
            width = (Double(model.gridSize.width) * model.tileSize.width * 2) * 0.75 + (model.tileSize.width / 2)
            height = (Double(model.gridSize.height) * model.tileSize.height * 2) + model.tileSize.height
        } else {
            width = (Double(model.gridSize.width) * model.tileSize.width * 2) + model.tileSize.width
            height = (Double(model.gridSize.height) * model.tileSize.height * 2) * 0.75 + (model.tileSize.height / 2)
        }
        
        super.init(frame: CGRect(x: 0, y: 0, width: width, height: height))
        
        self.backgroundColor = UIColor.whiteColor()
        
    }
    
    func playerOneAction(gesture : UIPanGestureRecognizer) {
        print("player one pan gesture rec")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, UIColor.clearColor().CGColor)
        CGContextFillRect(context, rect)
        
        UIColor.lightGrayColor().setStroke()
        UIColor.cyanColor().setFill()
        
        for (_, tile) in HexKit.sharedInstance.tiles {
            drawBezierPath(tile)
        }
        
        for (_, tile) in HexKit.sharedInstance.tiles {
            drawCoordLabel(tile)
        }
        
    }
    
    func drawCoordLabel(tile : Tile) {
        
        let text: NSString = "q:\(tile.hex.q), r:\(tile.hex.r)"
        let font = UIFont(name: "Helvetica", size: 14.0)
        
        let textRect : CGRect = Rect.CG(tile.rect)
        let textStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        textStyle.alignment = NSTextAlignment.Center
        let textColor = UIColor.blackColor()
        
        if let actualFont = font {
            let textFontAttributes = [
                NSFontAttributeName: actualFont,
                NSForegroundColorAttributeName: textColor,
                NSParagraphStyleAttributeName: textStyle
            ]
            
            let textSize : CGSize = text.sizeWithAttributes(textFontAttributes)
            
            text.drawInRect(CGRectOffset(textRect, 0, textRect.height/2 - textSize.height/2), withAttributes: textFontAttributes)
        }
        
    }
    
    func drawBezierPath(tile : Tile) {
        
        let sides : Int = 6
        let path = UIBezierPath()
        
        for var i = 0; i <= sides; ++i {
            if (i==0) {
                path.moveToPoint(Point.CG(tile.hexCorners[i]))
            } else {
                path.addLineToPoint(Point.CG(tile.hexCorners[i]))
            }
        }
        
        path.fillWithBlendMode(CGBlendMode.Normal, alpha: 0.5)
        path.lineWidth = 0.5
        path.strokeWithBlendMode(CGBlendMode.Darken, alpha: 0.5)
        path.stroke()
        
    }
    
}
