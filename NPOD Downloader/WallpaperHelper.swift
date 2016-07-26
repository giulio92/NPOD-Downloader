//
//  WallpaperHelper.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 19/07/16.
//  Copyright © 2016 Giulio Lombardo. All rights reserved.
//

import AppKit

class WallpaperHelper {
	class func isRetina(imagePath: NSURL) -> Bool {
		var deviceHasRetinaFeature: Bool = Bool()

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

		let imageData: NSImage = NSImage(contentsOfURL: imagePath)!

		return imageData.size.width > (NSScreen.mainScreen()!.frame.width * 2) && imageData.size.height > (NSScreen.mainScreen()!.frame.height * 2)
	}

	class func setWallpaperWithNodeID(nodeID: String) {
		let selectedImageData: [String: String] = ["": ""]
		let imageName: String = NSURL(string: selectedImageData["imageURL"]!)!.pathComponents!.last!
		let pictureDirectory: NSURL = NSFileManager.defaultManager().URLsForDirectory(.PicturesDirectory, inDomains: .UserDomainMask).first!

		for screen in NSScreen.screens()! {
			do {
				try NSWorkspace.sharedWorkspace().setDesktopImageURL(pictureDirectory.URLByAppendingPathComponent(imageName), forScreen: screen, options: ["": ""])
			} catch let error as NSError {
				#if DEBUG
					print(error)
				#endif
			}
		}

		//self.currentImageName.title = selectedImageData["title"]

		NSUserDefaults.standardUserDefaults().setValue(nodeID, forKey: "currentNID")
	}
}