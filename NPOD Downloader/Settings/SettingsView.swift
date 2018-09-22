//
//  SettingsView.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 22/09/18.
//  Copyright © 2018 Giulio Lombardo. All rights reserved.
//

import AppKit

final class SettingsView: NSView {
    @IBOutlet private var imageView: NSImageView!
    @IBOutlet private var retinaBadgeIcon: NSImageView!
    @IBOutlet private var previousImageButton: NSButton!
    @IBOutlet private var nextImageButton: NSButton!
    @IBOutlet private var keepImageButton: NSButton!
    @IBOutlet private var imageTitle: NSTextField!
    @IBOutlet private var imageDescription: NSTextField!

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
}
