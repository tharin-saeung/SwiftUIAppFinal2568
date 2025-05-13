//
//  plistLoader.swift
//  finalProject2566
//
//  Created by Tharin Saeung on 21/11/2566 BE.
//

import UIKit

class plistLoader: NSObject {
    func loadMyPlist(name: String) -> [String:[String:[String]]] {
        let url = Bundle.main.url(forResource: name, withExtension: "plist")!
        let testData = try! Data(contentsOf: url)
        let myPlist = try! PropertyListSerialization.propertyList(from: testData, format: nil)
        return myPlist as! [String:[String:[String]]]
    }
    func loadMyPlistDict(name: String) -> [String:String] {
        let url = Bundle.main.url(forResource: name, withExtension: "plist")!
        let testData = try! Data(contentsOf: url)
        let myPlist = try! PropertyListSerialization.propertyList(from: testData, format: nil)
        return myPlist as! [String:String]
    }
    func loadMyPlistInt(name: String) -> [String:Int] {
        let url = Bundle.main.url(forResource: name, withExtension: "plist")!
        let testData = try! Data(contentsOf: url)
        let myPlist = try! PropertyListSerialization.propertyList(from: testData, format: nil)
        return myPlist as! [String:Int]
    }
}
