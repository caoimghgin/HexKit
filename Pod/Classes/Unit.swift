//
//  Unit.swift
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

public class Unit : UIView {
    
    enum Alliance : Int {
        case Red
        case Blue
        case Uncontested
    }
    
    internal var alliance = Alliance.Blue
    private var movementPoints = 3
    internal var movementMaximum = 200
    internal var movementRemaining = 3
    internal var imageView = UIImageView.init(image: UIImage.init(named: "BritishTank"))
    
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView.image = UIImage.init(named: "BritishTank")
        self.imageView.center = self.center
        self.addSubview(self.imageView);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "endOfTurnNotificationAction:", name:"EndOfTurnNotification", object: nil)

    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        // perform the deinitialization
        print("deinit...")
    }
    
    func endOfTurnNotificationAction(notification: NSNotification) {
        movementRemaining = movementPoints
    }
}

class Infantry: Unit {
    
    required init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView.image = UIImage.init(named: "BritishInfantry")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GermanTank: Unit {
    
    required init(frame: CGRect) {
        super.init(frame: frame)
        self.imageView.image = UIImage.init(named: "GermanTank")
        self.alliance = Alliance.Red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
