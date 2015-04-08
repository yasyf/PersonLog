//
//  MyAppDelegate.swift
//  FishBowl
//
//  Created by Yasyf Mohamedali on 2015-04-08.
//  Copyright (c) 2015 com.fishbowl. All rights reserved.
//

import Foundation
import CoreData
import CoreBluetooth

private let _myAppDelegate = MyAppDelege()

class MyAppDelege {
    let serviceType = "personlog-disc"
    let beaconID = NSUUID(UUIDString: "F8F1A882-14FF-4F5D-A4A2-0308AB0644D8")!
    let characteristicID = CBUUID(string: "C7F7729A-F744-49E7-AE94-649D14FE2327")
    
    let managedObjectContext: NSManagedObjectContext?
    
    init() {
        let appDelegate = UIApplication.sharedApplication().delegate!
        let originalClass:AnyClass = object_setClass(appDelegate, AppDelegate.self)
        let myAppDelegate = appDelegate as AppDelegate
        managedObjectContext = myAppDelegate.managedObjectContext
        object_setClass(appDelegate, originalClass)
    }
    
     class var sharedInstance: MyAppDelege {
        return _myAppDelegate
    }
    
    lazy var peer: Peer = {
        return Peer()
    }()
    
    lazy var broadcaster: Broadcaster = {
        return Broadcaster(peer: self.peer, serviceType: self.serviceType, beaconID: self.beaconID, characteristicID: self.characteristicID)
    }()
    
    lazy var discoverer: Discoverer = {
        return Discoverer(peer: self.peer, serviceType: self.serviceType, beaconID: self.beaconID, characteristicID: self.characteristicID)
    }()

}