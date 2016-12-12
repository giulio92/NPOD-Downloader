//
//  WallpaperHelper.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 19/07/16.
//  Copyright © 2016 Giulio Lombardo. All rights reserved.
//

import AppKit

class WallpaperHelper {
	class func isRetina(imageData: [String: String]) -> Bool {
		var deviceHasRetinaFeature: Bool = Bool()

		// Now we need to check if the user has at least a Retina display
		// by looping through the displays, if he does not we will exit using
		// the guard statement below since the isRetina func it's useless
		// if the Mac does not have a Retina display
		for screen in NSScreen.screens()! {
			if screen.backingScaleFactor < 2 {
				deviceHasRetinaFeature = false
			} else {
				deviceHasRetinaFeature = true
				break
			}
		}

		guard deviceHasRetinaFeature else {
			return false
		}

		let pictureDirectory: NSURL = NSFileManager.defaultManager().URLsForDirectory(.PicturesDirectory, inDomains: .UserDomainMask).first!
		let image: NSImage = NSImage(contentsOfURL: pictureDirectory.URLByAppendingPathComponent(imageData["filename"]!)!)!

		// If the image width and height values are greater than or equal to the
		// double of the mainScreen's width and height values the image is
		// Retina ready
		return image.size.width >= (NSScreen.mainScreen()!.frame.width * 2) && image.size.height >= (NSScreen.mainScreen()!.frame.height * 2)
	}

	class func setWallpaperWithImageData(imageData: [String: String]) {
		let pictureDirectory: NSURL = NSFileManager.defaultManager().URLsForDirectory(.PicturesDirectory, inDomains: .UserDomainMask).first!

		let image: NSImage = NSImage(contentsOfURL: pictureDirectory.URLByAppendingPathComponent(imageData["filename"]!)!)!

		for screen in NSScreen.screens()! {
			do {
				var desktopImageOptions: [String: UInt] = ["": 0]

				// If the image width and height values are smaller than the
				// screen's widht and height, each one multiplied by the screen
				// backingScaleFactor, we need to scale the image proportionally
				if (image.size.width < (screen.frame.width * screen.backingScaleFactor)) || (image.size.height < (screen.frame.height * screen.backingScaleFactor)) {
					desktopImageOptions[NSWorkspaceDesktopImageScalingKey] = NSImageScaling.ScaleProportionallyUpOrDown.rawValue
				}

				try NSWorkspace.sharedWorkspace().setDesktopImageURL(pictureDirectory.URLByAppendingPathComponent(imageData["filename"]!)!, forScreen: screen, options: desktopImageOptions)
			} catch let error as NSError {
				#if DEBUG
					print(error)
				#endif
			}
		}

		NSUserDefaults.standardUserDefaults().setValue(imageData["nodeID"], forKey: "currentNID")
	}
}
