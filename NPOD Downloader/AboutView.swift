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

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.

		let versionNumber: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
		appVersionLabel.cell?.title = "Version: " + versionNumber
    }

	@IBAction func launchGitHubPage(_ sender: NSButton) {
		NSWorkspace.shared().open(URL(string: "https://github.com/giulio92/NPOD-Downloader")!)
	}
}
