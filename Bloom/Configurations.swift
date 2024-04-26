//
//  Configurations.swift
//  Bloom
//
//  Created by Andrew Addis on 2024/04/21.
//

import Foundation

func readPlist(name: String) -> [String: AnyObject]? {
    if let path = Bundle.main.path(forResource: name, ofType: "plist"),
       let xml = FileManager.default.contents(atPath: path) {
        return (try? PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: nil)) as? [String: AnyObject]
    }
    return nil
}
