//
//  SettingsView.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 22/09/18.
//  Copyright © 2018 Giulio Lombardo. All rights reserved.
//

import AppKit

final class SettingsView: NSView {
	@IBOutlet private weak var imageView: NSImageView!
	@IBOutlet private weak var retinaBadgeIcon: NSImageView!
	@IBOutlet private weak var previousImageButton: NSButton!
	@IBOutlet private weak var nextImageButton: NSButton!
	@IBOutlet private weak var keepImageButton: NSButton!
	@IBOutlet private weak var imageTitle: NSTextField!
	@IBOutlet private weak var imageDescription: NSTextField!

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
}
