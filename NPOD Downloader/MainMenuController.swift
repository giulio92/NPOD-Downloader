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

		// In order to check the last day we dowloaded the nodeIDs we still need
		// to check if we downloaded the at least once by checking the presence
		// of the previousNIDs dictionary, otherwise the application will crash
		if NSUserDefaults.standardUserDefaults().dictionaryForKey("previousNIDs") != nil {
			let previousNodes: [String : AnyObject] = NSUserDefaults.standardUserDefaults().dictionaryForKey("previousNIDs")!

			let dateComparison: NSComparisonResult = NSCalendar.currentCalendar().compareDate(NSDate(), toDate: previousNodes["downloadDate"] as! NSDate, toUnitGranularity: .Day)

			// If we already checked for today's nodeIDs from NASA servers we
			// avoid re-downloading them again
			if dateComparison == .OrderedSame {
				return
			}
		}

		self.currentImageName.title = "Connecting to NASA..."

		GrandNetworkDispatch.getUbernodes({
			(ubernodes) in

			// Here we initialize the dictionary and we set the current date so
			// we will now when the nodeIDs were downloaded
			var tempDict: [String : AnyObject] = ["downloadDate": NSDate()]
			var nodeIDs: [String] = Array()

			for ubernode in ubernodes {
				nodeIDs.append(ubernode["nid"]!)
			}

			tempDict["nodeIDs"] = nodeIDs

			// Here we save the dictionary to NSUserDefaults for the future
			NSUserDefaults.standardUserDefaults().setObject(tempDict, forKey: "previousNIDs")

			self.currentImageName.title = "Retrieving image details..."

			// Now we download the image details of the most recent nodeID
			// taking it from the nodeIDs array with the first method
			GrandNetworkDispatch.getImageDetailsWithNodeID(nodeIDs.first!, success: {
				(imageDetails) in

				self.currentImageName.title = imageDetails["title"]!

				GrandNetworkDispatch.downloadImageWithData(imageDetails, progressUpdate: nil, success: {
					(downloadedPath) in

					// If the user does not want to keep a particular previous
					// image as wallpaper we set the current NASA Picture of the
					// Day as wallpaper
					if NSUserDefaults.standardUserDefaults().boolForKey("keepImage") == false {
						WallpaperHelper.setWallpaperWithImageData(imageDetails)
					}
					}, failure: {
						(errorData) in
						self.currentImageName.title = errorData as! String
				})
				}, failure: {
					(errorData) in
					self.currentImageName.title = errorData as! String
			})
			}, failure: {
				(errorData) in
				self.currentImageName.title = errorData as! String
		})
	}

	@IBAction func preferencesAction(sender: NSMenuItem) {
		
	}

	@IBAction func aboutAction(sender: NSMenuItem) {

	}

	@IBAction func quitAction(sender: NSMenuItem) {
		NSApplication.sharedApplication().terminate(self)
	}
}