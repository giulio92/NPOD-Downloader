//
//  PreferencesView.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 22/07/16.
//  Copyright © 2016 Giulio Lombardo. All rights reserved.
//

import AppKit

final class PreferencesView: NSView {
	@IBOutlet private weak var imageView: NSImageView!
	@IBOutlet private weak var retinaBadgeIcon: NSImageView!
	@IBOutlet private weak var previousImageButton: NSButton!
	@IBOutlet private weak var nextImageButton: NSButton!
	@IBOutlet private weak var keepImageButton: NSButton!
	@IBOutlet private weak var imageTitle: NSTextField!
	@IBOutlet private weak var imageDescription: NSTextField!

	private var currentImageIndex: Int = 0

	override func draw(_ dirtyRect: NSRect) {
		super.draw(dirtyRect)

		// Drawing code here.

		if UserDefaults.standard.bool(forKey: "keepImage") {
			keepImageButton.state = UserDefaults.standard.bool(forKey: "keepImage").hashValue
		}
	}

	@IBAction private final func previousImage(_ sender: NSButton) {
		currentImageIndex += 1

		if let previousNodes: [String : Any] = UserDefaults.standard.dictionary(forKey: "previousNIDs") {
			guard let ubernodes: [String] = previousNodes["nodeIDs"] as? [String] else {
				return
			}

			guard let imageDatabase: [String : Any] = UserDefaults.standard.dictionary(forKey: "imageDatabase") else {
				return
			}

			if let imageDict: [String : String] = imageDatabase[ubernodes[currentImageIndex]] as? [String : String] {
				retinaBadgeIcon.isHidden = WallpaperHelper.isRetina(imageDict)
			} else {
				GrandNetworkDispatch.getImageDetailsWithNodeID(ubernodes[currentImageIndex], success: { [weak self] imageDetails in
					guard let weakSelf = self else {
						return
					}

					guard let imageDict: [String : String] = imageDatabase[ubernodes[weakSelf.currentImageIndex]] as? [String : String] else {
						return
					}

					self?.retinaBadgeIcon.isHidden = WallpaperHelper.isRetina(imageDict)
				}, failure: { errorData in

				})
			}
		}
	}

	@IBAction private final func nextImage(_ sender: NSButton) {
		currentImageIndex -= 1

		if UserDefaults.standard.dictionary(forKey: "previousNIDs") != nil {
			let previousNodes: [String : AnyObject] = UserDefaults.standard.dictionary(forKey: "previousNIDs")! as [String : AnyObject]
			let ubernodes: [String] = previousNodes["nodeIDs"] as! [String]
			let imageDatabase: [String : [String: String]] = UserDefaults.standard.dictionary(forKey: "imageDatabase") as! [String : [String: String]]

			retinaBadgeIcon.isHidden = WallpaperHelper.isRetina(imageDatabase[ubernodes[currentImageIndex]]!)
		}
	}

	@IBAction private final func setImageAsWallpaper(_ sender: NSButton) {

	}

	@IBAction private final func keepImage(_ sender: NSButton) {
		UserDefaults.standard.set(sender.state, forKey: "keepImage")
	}
}
