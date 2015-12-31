//
//  Grid.swift
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
        
//        self.backgroundColor = UIColor.whiteColor()
        self.backgroundColor = UIColor.clearColor()
        
        
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
//        UIColor.cyanColor().setFill()
//        UIColor.whiteColor().setFill()
        UIColor.clearColor().setFill()

        
        for (_, tile) in HexKit.sharedInstance.tiles {
            drawBezierPath(tile)
        }
        
//        for (_, tile) in HexKit.sharedInstance.tiles {
//            drawCoordLabel(tile)
//        }
        
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
        path.lineWidth = 1.0
        path.strokeWithBlendMode(CGBlendMode.Darken, alpha: 0.5)
        path.stroke()
        
    }
    
}
