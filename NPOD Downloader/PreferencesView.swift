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

	override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)

		// Drawing code here.

		if UserDefaults.standard.bool(forKey: "keepImage") {
			keepImageButton.state = UserDefaults.standard.bool(forKey: "keepImage").hashValue
		}
	}

	@IBAction func previousImage(_ sender: NSButton) {
		currentImageIndex += 1

		if UserDefaults.standard.dictionary(forKey: "previousNIDs") != nil {
			let previousNodes: [String : AnyObject] = UserDefaults.standard.dictionary(forKey: "previousNIDs")! as [String : AnyObject]
			let ubernodes: [String] = previousNodes["nodeIDs"] as! [String]
			let imageDatabase: [String : [String: String]] = UserDefaults.standard.dictionary(forKey: "imageDatabase") as! [String : [String: String]]

			if imageDatabase[ubernodes[currentImageIndex]] != nil {
				retinaBadgeIcon.isHidden = WallpaperHelper.isRetina(imageDatabase[ubernodes[currentImageIndex]]!)
			} else {
				GrandNetworkDispatch.getImageDetailsWithNodeID(ubernodes[currentImageIndex], success: {
					(imageDetails) in

					let imageDatabase: [String : [String: String]] = UserDefaults.standard.dictionary(forKey: "imageDatabase") as! [String : [String: String]]

					self.retinaBadgeIcon.isHidden = WallpaperHelper.isRetina(imageDatabase[ubernodes[self.currentImageIndex]]!)
					}, failure: {
						(errorData) in
				})
			}
		}
	}

	@IBAction func nextImage(_ sender: NSButton) {
		currentImageIndex -= 1

		if UserDefaults.standard.dictionary(forKey: "previousNIDs") != nil {
			let previousNodes: [String : AnyObject] = UserDefaults.standard.dictionary(forKey: "previousNIDs")! as [String : AnyObject]
			let ubernodes: [String] = previousNodes["nodeIDs"] as! [String]
			let imageDatabase: [String : [String: String]] = UserDefaults.standard.dictionary(forKey: "imageDatabase") as! [String : [String: String]]

			retinaBadgeIcon.isHidden = WallpaperHelper.isRetina(imageDatabase[ubernodes[currentImageIndex]]!)
		}
	}

	@IBAction func setImageAsWallpaper(_ sender: NSButton) {

	}

	@IBAction func keepImage(_ sender: NSButton) {
		UserDefaults.standard.set(Bool(sender.state), forKey: "keepImage")
	}
}
