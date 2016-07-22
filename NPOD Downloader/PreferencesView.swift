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
	
	override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }

	@IBAction func setImageAsWallpaper(sender: NSButton) {
	
	}
}