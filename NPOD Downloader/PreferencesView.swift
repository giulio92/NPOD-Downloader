//
//  PreferencesView.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 22/07/16.
//  Copyright © 2016 Giulio Lombardo. All rights reserved.
//

import AppKit

class PreferencesView: NSView {
	@IBOutlet weak var imageView: NSImageView!
	@IBOutlet weak var retinaBadgeIcon: NSImageView!
	@IBOutlet weak var previousImageButton: NSButton!
	@IBOutlet weak var nextImageButton: NSButton!
	@IBOutlet weak var keepImageButton: NSButton!
	@IBOutlet weak var imageTitle: NSTextField!
	@IBOutlet weak var imageDescription: NSTextField!
	var currentImageIndex: Int = 0

	override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.

		if NSUserDefaults.standardUserDefaults().boolForKey("keepImage") {
			keepImageButton.state = NSUserDefaults.standardUserDefaults().boolForKey("keepImage").hashValue
		}
    }

	@IBAction func previousImage(sender: NSButton) {
		currentImageIndex += 1

		if NSUserDefaults.standardUserDefaults().dictionaryForKey("previousNIDs") != nil {
			let previousNodes: [String : AnyObject] = NSUserDefaults.standardUserDefaults().dictionaryForKey("previousNIDs")!
			let ubernodes: [String] = previousNodes["nodeIDs"] as! [String]
			let imageDatabase: [String : [String: String]] = NSUserDefaults.standardUserDefaults().dictionaryForKey("imageDatabase") as! [String : [String: String]]

			if imageDatabase[ubernodes[currentImageIndex]] != nil {
				retinaBadgeIcon.hidden = WallpaperHelper.isRetina(imageDatabase[ubernodes[currentImageIndex]]!)
			} else {
				GrandNetworkDispatch.getImageDetailsWithNodeID(ubernodes[currentImageIndex], success: { (imageDetails) in
					let imageDatabase: [String : [String: String]] = NSUserDefaults.standardUserDefaults().dictionaryForKey("imageDatabase") as! [String : [String: String]]
					
					self.retinaBadgeIcon.hidden = WallpaperHelper.isRetina(imageDatabase[ubernodes[self.currentImageIndex]]!)
					}, failure: {
						(errorData) in
				})
			}
		}
	}

	@IBAction func nextImage(sender: NSButton) {
		currentImageIndex -= 1

		if NSUserDefaults.standardUserDefaults().dictionaryForKey("previousNIDs") != nil {
			let previousNodes: [String : AnyObject] = NSUserDefaults.standardUserDefaults().dictionaryForKey("previousNIDs")!
			let ubernodes: [String] = previousNodes["nodeIDs"] as! [String]
			let imageDatabase: [String : [String: String]] = NSUserDefaults.standardUserDefaults().dictionaryForKey("imageDatabase") as! [String : [String: String]]

			retinaBadgeIcon.hidden = WallpaperHelper.isRetina(imageDatabase[ubernodes[currentImageIndex]]!)
		}
	}

	@IBAction func setImageAsWallpaper(sender: NSButton) {
		
	}

	@IBAction func keepImage(sender: NSButton) {
		NSUserDefaults.standardUserDefaults().setBool(Bool(sender.state), forKey: "keepImage")
	}
}