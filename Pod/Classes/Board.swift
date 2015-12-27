//
//  Board.swift
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

class Board : UIView, UIGestureRecognizerDelegate {
    
    var artwork = Artwork()
    var arena = Arena()
    var grid = Grid()
    var transit = Transit()
    var sceneDelegate = HexKitSceneDelegate?()

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
    
        let tile = Touch.tile(gesture)
        
        if (tile.units.count > 0) {
            
            self.sceneDelegate?.tileContainingUnitsWasTapped(tile)
            
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

class Artwork : UIImageView {
    
}

class Arena: UIView {
    
}
