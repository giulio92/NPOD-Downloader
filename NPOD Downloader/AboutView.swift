//
//  AboutView.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 21/07/16.
//  Copyright © 2016 Giulio Lombardo. All rights reserved.
//

import AppKit

class AboutView: NSView {
	@IBOutlet weak var appVersionLabel: NSTextField!

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.

		let versionNumber: String = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
		appVersionLabel.cell?.title = "Version: " + versionNumber
    }

	@IBAction func launchGitHubPage(sender: NSButton) {
		NSWorkspace.sharedWorkspace().openURL(NSURL(string: "https://github.com/giulio92/NPOD-Downloader")!)
	}
}
