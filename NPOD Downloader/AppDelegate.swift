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

		NSUserDefaults.standardUserDefaults().registerDefaults(["NSApplicationCrashOnExceptions": "true"])
		
		Fabric.with([Crashlytics.self])

		if NSUserDefaults.standardUserDefaults().dictionaryForKey("previousNIDs") != nil {
			let previousNodes: [String : AnyObject] = NSUserDefaults.standardUserDefaults().dictionaryForKey("previousNIDs")!

			let dateComparison: NSComparisonResult = NSCalendar.currentCalendar().compareDate(NSDate(), toDate: previousNodes["downloadDate"] as! NSDate, toUnitGranularity: .Day)

			guard dateComparison != .OrderedSame else {
				return
			}
		}

		GrandNetworkDispatch.getUbernodes({
			(data) in

			var tempDict: [String : AnyObject] = ["downloadDate": NSDate()]
			var nodeIDs: [String] = Array()

			for ubernode in data {
				nodeIDs.append(ubernode["nid"]!)
			}

			tempDict["nodeIDs"] = nodeIDs

			NSUserDefaults.standardUserDefaults().setObject(tempDict, forKey: "previousNIDs")

			GrandNetworkDispatch.getImageDetailsWithNodeID(nodeIDs.first!, success: {
				(data) in

				GrandNetworkDispatch.downloadImage(data["url"]!, progressUpdate: nil, success: {
					(downloadedPath) in

					WallpaperHelper.setWallpaperWithImagePath(downloadedPath)
					}, failure: {
						(errorData) in

				})
				}, failure: {
					(errorData) in

			})

			}, failure: {
				(errorData) in
				
		})
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}
}