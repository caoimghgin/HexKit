//
//  Dictionary+HexKit.swift
//  Pods
//
//  Created by Kevin Muldoon on 12/21/15.
//
//

extension Dictionary {

    static func loadProperties(filename: String) -> Dictionary<String, AnyObject>? {
        if let path = NSBundle.mainBundle().pathForResource(filename, ofType: "plist"), result = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            return result
        }
        print("Could not find file: \(filename)")
        return nil
    }
    
}
