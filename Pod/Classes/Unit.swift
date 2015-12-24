//
//  Unit.swift
//  HexKit
//
//  Created by Kevin Muldoon on 11/6/15.
//  Copyright © 2015 RobotJackalope. All rights reserved.
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
