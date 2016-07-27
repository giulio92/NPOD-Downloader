//
//  MainMenuController.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 14/07/16.
//  Copyright © 2016 Giulio Lombardo. All rights reserved.
//

import Alamofire
import Fabric
import Crashlytics

class MainMenuController: NSObject {
	@IBOutlet weak var applicationMenu: NSMenu!
	@IBOutlet weak var currentImageName: NSMenuItem!

	let statusItem: NSStatusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)

	override func awakeFromNib() {
		#if DEBUG
			Fabric.sharedSDK().debug = true
		#endif

		#if DEBUG
			NSUserDefaults.standardUserDefaults().removePersistentDomainForName(NSBundle.mainBundle().bundleIdentifier!)
		#endif

		NSUserDefaults.standardUserDefaults().registerDefaults(["NSApplicationCrashOnExceptions": "true"])

		Fabric.with([Crashlytics.self])

		statusItem.image = NSImage(named: "MenuIcon")
		statusItem.menu = applicationMenu

		if NSUserDefaults.standardUserDefaults().dictionaryForKey("previousNIDs") != nil {
			let previousNodes: [String : AnyObject] = NSUserDefaults.standardUserDefaults().dictionaryForKey("previousNIDs")!

			let dateComparison: NSComparisonResult = NSCalendar.currentCalendar().compareDate(NSDate(), toDate: previousNodes["downloadDate"] as! NSDate, toUnitGranularity: .Day)

			if dateComparison == .OrderedSame {
				return
			}
		}

		GrandNetworkDispatch.getUbernodes({
			(ubernodes) in

			var tempDict: [String : AnyObject] = ["downloadDate": NSDate()]
			var nodeIDs: [String] = Array()

			for ubernode in ubernodes {
				nodeIDs.append(ubernode["nid"]!)
			}

			tempDict["nodeIDs"] = nodeIDs

			NSUserDefaults.standardUserDefaults().setObject(tempDict, forKey: "previousNIDs")

			GrandNetworkDispatch.getImageDetailsWithNodeID(nodeIDs.first!, success: {
				(imageDetails) in

				GrandNetworkDispatch.downloadImageWithData(imageDetails, progressUpdate: nil, success: {
					(downloadedPath) in
					self.currentImageName.title = imageDetails["title"]!

					if NSUserDefaults.standardUserDefaults().boolForKey("keepImage") == false {
						WallpaperHelper.setWallpaperWithImageData(imageDetails)
					}
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

	@IBAction func quitAction(sender: NSMenuItem) {
		NSApplication.sharedApplication().terminate(self)
	}
}