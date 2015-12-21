//
//  ViewController.swift
//  HexKit
//
//  Created by Kevin Muldoon on 12/21/2015.
//  Copyright (c) 2015 Kevin Muldoon. All rights reserved.
//

import UIKit
import HexKit

class ViewController: UIViewController {
    
    private lazy var scene:Scene = {
        HexKit.sharedInstance.start("Scene")
        return Scene(frame: self.view.frame)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scene)
        scene.placeUnit(scene.tile(q: 1, r: 1))
        scene.placeUnit(scene.tile(q: 2, r: 1))
        scene.placeUnit(scene.tile(q: 3, r: 0))
        scene.placeUnit(scene.tile(q: 3, r: -1))
        scene.placeUnit(scene.tile(q: 2, r: -1))
        scene.placeUnit(scene.tile(q: 1, r: 0))
        
        self.navigationController?.toolbarHidden = false;
        self.navigationController?.navigationBarHidden = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }

}

