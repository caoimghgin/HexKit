//
//  Scene.swift
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

public protocol HexKitSceneDelegate {
    func tileWasTapped(tile : Tile)
}

public class Scene: UIScrollView, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    var board : Board
    var sceneDelegate = HexKitSceneDelegate?()
    
    /**
     Creates a HexKit scene.
     
     - parameter controller: UIViewController which presents the scene
     - parameter parameters: pList file parameters

     - returns: Scene
     */
    public convenience init(controller:UIViewController, parameters: String) {
        HexKit.sharedInstance.start(parameters)
        self.init(frame:controller.view.frame)
        self.sceneDelegate = controller as? HexKitSceneDelegate
        self.board.sceneDelegate = self.sceneDelegate
    }

    public override init(frame: CGRect) {
        
        self.board = Board()
        super.init(frame: frame)
        
        contentSize = CGSize(width: board.frame.width/2, height: board.frame.height/2)
        showsHorizontalScrollIndicator = true;
        showsVerticalScrollIndicator = true;
        autoresizingMask = [UIViewAutoresizing.FlexibleBottomMargin, UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleBottomMargin, UIViewAutoresizing.FlexibleTopMargin, UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        minimumZoomScale = 0.5
        maximumZoomScale = 1.0
        zoomScale = 1.0
        delegate = self
        
        addSubview(board)
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapGestureRecognizerAction:")
        tapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(tapGesture)
        
    }
    
//    + (UIImage *) imageWithView:(UIView *)view
//    {
//    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0f);
//    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
//    UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return snapshotImage;
//    }
    
    public func getGridAsImage() -> UIImage {
        return Scene.imageWithView(self.board.grid)
    }
    
    class func imageWithView(view : UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 2.0)
        view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: false)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshot
    }
    
    
    func tapGestureRecognizerAction(gesture : UITapGestureRecognizer) {
        self.sceneDelegate?.tileWasTapped(Touch.tile(gesture))
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createUnit() -> Unit {
        return Unit(frame: CGRectMake(0, 0, 44, 44))
    }
    
    func createInfantry() -> Unit {
        return Infantry(frame: CGRectMake(0, 0, 44, 44))
    }
    
    func createGerman() -> Unit {
        return GermanTank(frame: CGRectMake(0, 0, 44, 44))
    }
    
    func placeUnit(unit: Unit, tile:Tile) {
        unit.center = Point.CG(tile.center)
        tile.units.append(unit)
        board.arena.addSubview(unit)
    }
    
    public func placeUnit(tile:Tile) {
        let unit = self.createUnit()
        self.placeUnit(unit, tile: tile)
    }
    
    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return board
    }
    
    public func scrollViewDidZoom(scrollView: UIScrollView) {
        print("zoom zoom -> \(scrollView.zoomScale)")
    }
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false;
    }
    
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        //        return false; /* uncomment to disable UIScrollView scrolling **/
        
        var result:Bool
        let tile = self.tile(touch.locationInView(self));
        if ( tile.units.count > 0 ) {
            
            let unit = tile.units.first
            
            if (unit?.alliance == HexKit.sharedInstance.turn) {
                return false
            } else {
                return true
            }
            
        } else {
            result = true
        }
        return result
    }
    
    public func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        //        scrollView.contentSize = CGSize(width: self.frame.width / 2, height: self.frame.height / 2)
        scrollView.contentSize = CGSizeMake(board.frame.size.width * scale, board.frame.size.height * scale)
    }
    
    //    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    //
    //        let touch = touches.first
    //        let point = touch!.locationInView(self)
    //        let tile = self.tile(point);
    //
    ////        print("expected = \(tile.hex)")
    ////        print("actual = Touch.hex(CGPointMake\(point))")
    ////        print("XCTAssertEqual(actual.r, expected.r, \"\")")
    ////        print("XCTAssertEqual(actual.q, expected.q, \"\")")
    ////        print("\r")
    //
    ////        print(tile.hex)
    //    }
    
    public func tile(q q:Int, r:Int) -> Tile {
        print("q;\(q)r:\(r)");
        let tile = HexKit.sharedInstance.tile(q: q, r : r)!
        return tile
        
    }
    
    public func tile(point:CGPoint) -> Tile {
        let hex = Touch.hex(point)
        let tile = HexKit.sharedInstance.tile(hex)!
        return tile
    }
    
}

class Touch {
    
    class func hex(point:CGPoint) -> Hex {
        
        switch (HexKit.sharedInstance.gridTileShape) {
            
        case HexKit.GridTileShape.OddFlat:
            
            return Touch.pointToAxial_Odd_Q(point)
            
        case HexKit.GridTileShape.OddPoint:
            
            return Touch.pointToAxial_Odd_R(point)
            
        case HexKit.GridTileShape.EvenFlat:
            
            return Touch.pointToAxial_Even_Q(point)
            
        case HexKit.GridTileShape.EvenPoint:
            
            return Touch.pointToAxial_Even_R(point)
            
        }
        
    }
    
    class func tile(point: CGPoint) -> Tile {
        
        return HexKit.sharedInstance.tile(Touch.hex(point))!
        
    }
    
    class func tile(gesture:UIGestureRecognizer) -> Tile {
        
        return Touch.tile(gesture.locationInView(gesture.view))
        
    }
    
    class func tile(touch:UITouch) -> Tile {
        
        return Touch.tile(touch.locationInView(touch.view))
    }
    
    class func pointToAxial_Odd_R(point:CGPoint) -> Hex {
        
        let tile = HexKit.sharedInstance.tile()
        
        let x = (Double(point.x) - (tile!.ø / 2)) / tile!.ø;
        let y = Double(point.y) / (tile!.Ø / 2)
        let r = floor((floor(y - x) + floor(x + y)) / 3);
        let q = floor((floor(2 * x + 1) + floor(x + y)) / 3) - r;
        
        return Hex.Convert(q:q, r:r)
    }
    
    class func pointToAxial_Even_R(point:CGPoint) -> Hex {
        
        let tile = HexKit.sharedInstance.tile()
        
        let x = (Double(point.x) - tile!.ø) / tile!.ø;
        let y = Double(point.y) / (tile!.Ø / 2)
        let r = floor((floor(y - x) + floor(x + y)) / 3);
        var q = floor((floor(2 * x + 1) + floor(x + y)) / 3) - r;
        if ( (r+1) % 2 == 0) { q = q + 1 }
        
        return Hex.Convert(q:q, r:r)
    }
    
    class func pointToAxial_Odd_Q(point:CGPoint) -> Hex {
        
        let tile = HexKit.sharedInstance.tile()
        
        let q = Double(point.x - CGFloat(tile!.Ø/8)) / (tile!.Ø * 0.75)
        
        let yx = Int(-floor(Double(q)/2))
        let yy = Double(floor(point.y)) / tile!.ø
        let r = Int(floor(yy)) + yx
        
        let coord = Hex(q: Int(r), r: Int(q))
        
        let result = closeAndHaveACigar(coord, point: point)
        return result;
    }
    
    class func pointToAxial_Even_Q(point:CGPoint) -> Hex {
        // TODO -
        return Hex(q: 0, r: 0)
    }
    
    class func closeAndHaveACigar(coord: Hex, point:CGPoint) -> Hex {
        
        let guess = HexKit.sharedInstance.tile(q:coord.r, r: coord.q)
        if (guess == nil) {return Hex(q:0, r:0)}
        
        var neighbors : [Tile] = HexKit.sharedInstance.neighbors(guess!)
        neighbors.append(guess!)
        
        for tile in neighbors {
            
            let dX = Double(point.x) - tile.center.x;
            let dY = Double(point.y) - tile.center.y;
            tile.delta = (dX * dX) + (dY * dY);
            
        }
        
        neighbors.sortInPlace{ $0.delta < $1.delta }
        return neighbors[0].hex
    }
    
}