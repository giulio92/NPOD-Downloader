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
	@IBOutlet weak var imageTitle: NSTextField!
	@IBOutlet weak var imageDescription: NSTextField!
	
	

	override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }

	@IBAction func setImageAsWallpaper(sender: NSButton) {
	
	}
}