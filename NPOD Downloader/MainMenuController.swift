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
	@IBOutlet weak var aboutWindow: NSWindow!
	@IBOutlet weak var appVersionLabel: NSTextField!

	let statusItem: NSStatusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)

	override func awakeFromNib() {
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

		statusItem.image = NSImage(named: "MenuIcon")
		statusItem.menu = applicationMenu

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

				GrandNetworkDispatch.downloadImage(imageDetails["imageURL"]!, progressUpdate: nil, success: {
					(downloadedPath) in

					self.currentImageName.title = imageDetails["title"]!

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

	@IBAction func aboutAction(sender: NSMenuItem) {
		aboutWindow.makeKeyAndOrderFront(sender)

		let versionNumber: String = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
		appVersionLabel.cell?.title = "Version: " + versionNumber
	}

	@IBAction func launchGitHubPage(sender: NSButton) {
		NSWorkspace.sharedWorkspace().openURL(NSURL(string: "https://github.com/giulio92/NPOD-Downloader")!)
	}

	@IBAction func quitAction(sender: NSMenuItem) {
		NSApplication.sharedApplication().terminate(self)
	}
}