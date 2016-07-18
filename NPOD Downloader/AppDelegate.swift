//
//  AppDelegate.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 13/07/16.
//  Copyright © 2016 Giulio Lombardo. All rights reserved.
//

import AppKit
import Fabric
import Crashlytics

@NSApplicationMain

class AppDelegate: NSObject, NSApplicationDelegate {
	func applicationDidFinishLaunching(aNotification: NSNotification) {
		// Insert code here to initialize your application
		#if DEBUG
			Fabric.sharedSDK().debug = true
		#endif

		NSUserDefaults.standardUserDefaults().registerDefaults(["NSApplicationCrashOnExceptions": "YES"])

		Fabric.with([Crashlytics.self])
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}
}