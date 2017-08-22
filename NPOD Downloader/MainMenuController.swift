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
	@IBOutlet private weak var applicationMenu: NSMenu!
	@IBOutlet private weak var currentImageName: NSMenuItem!

	private let statusItem: NSStatusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)

	override func awakeFromNib() {
		#if DEBUG
			Fabric.sharedSDK().debug = true
		#endif

		#if DEBUG
			UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
		#endif

		UserDefaults.standard.register(defaults: ["NSApplicationCrashOnExceptions": "true"])

		Fabric.with([Crashlytics.self])

		statusItem.image = NSImage(named: "MenuIcon")
		statusItem.menu = applicationMenu

		// In order to check the last day we dowloaded the nodeIDs we still need
		// to check if we downloaded the at least once by checking the presence
		// of the previousNIDs dictionary, otherwise the application will crash
		if UserDefaults.standard.dictionary(forKey: "previousNIDs") != nil {
			let previousNodes: [String : AnyObject] = UserDefaults.standard.dictionary(forKey: "previousNIDs")! as [String : AnyObject]

			let dateComparison: ComparisonResult = (Calendar.current as NSCalendar).compare(Date(), to: previousNodes["downloadDate"] as! Date, toUnitGranularity: .day)

			// If we already checked for today's nodeIDs from NASA servers we
			// avoid re-downloading them again
			if dateComparison == .orderedSame {
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

			tempDict["nodeIDs"] = nodeIDs as AnyObject?

			// Here we save the dictionary to NSUserDefaults for the future
			UserDefaults.standard.set(tempDict, forKey: "previousNIDs")

			self.currentImageName.title = "Retrieving image details..."

			// Now we download the image details of the most recent nodeID
			// taking it from the nodeIDs array with the first method
			GrandNetworkDispatch.getImageDetailsWithNodeID(nodeIDs.first!, success: {
				(imageDetails) in

				self.currentImageName.title = imageDetails["title"]!

				GrandNetworkDispatch.downloadImageWithData(imageDetails, progressUpdate: {
					(progress) in

				}, success: {
					(downloadedPath) in

					// If the user does not want to keep a particular previous
					// image as wallpaper we set the current NASA Picture of the
					// Day as wallpaper
					if UserDefaults.standard.bool(forKey: "keepImage") == false {
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

	@IBAction private func preferencesAction(_ sender: NSMenuItem) {
		
	}

	@IBAction private func aboutAction(_ sender: NSMenuItem) {

	}

	@IBAction private func quitAction(_ sender: NSMenuItem) {
		NSApplication.shared().terminate(self)
	}
}
