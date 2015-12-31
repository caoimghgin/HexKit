//
//  ViewController.swift
//  HexKit
//
//  Copyright © 2015 Kevin Muldoon.
//  https://github.com/caoimghgin/HexKit
//

import UIKit
import HexKit

class ViewController: UIViewController, HexKitSceneDelegate {
    
    private lazy var scene:Scene = {
        return Scene(controller: self, parameters: "Scene")
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
    
    override func viewDidAppear(animated: Bool) {
        //
        let image = scene.getGridAsImage()
        
        let documents = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let filePath = documents.stringByAppendingString("/grid.png")
        UIImagePNGRepresentation(image)?.writeToFile(filePath, atomically: true)

        print("")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true;
    }
    
    func tileWasTapped(tile:Tile) {
        
        if (tile.occupied()) {
            
            let info = tile.occupyingUnitsDetail()
            let alertController = UIAlertController(title: "Unit Detail", message: "We've returned a tile object containing all the units it contains. We can show more detailed information about those units here. Obviously, not in a standard UIAlertController but in something more customized.\r\r" + info, preferredStyle: .Alert)
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in}
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                
            }
            
        } else {
            
            print(tile)
            
        }
    }

}

