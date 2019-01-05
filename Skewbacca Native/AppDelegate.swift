//
//  AppDelegate.swift
//  Skewbacca Native
//
//  Created by Antonio Radovcic on 01.01.19.
//  Copyright © 2019 niorad. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var openMenuItem: NSMenuItem!
    @IBOutlet weak var exportMenuItem: NSMenuItem!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }


}

