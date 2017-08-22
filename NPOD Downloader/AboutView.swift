//
//  AboutView.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 21/07/16.
//  Copyright © 2016 Giulio Lombardo. All rights reserved.
//

import AppKit

final class AboutView: NSView {
	@IBOutlet private weak var appVersionLabel: NSTextField!

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.

		if let infoDictionary: [String : Any] = Bundle.main.infoDictionary {
			if let versionNumber: String = infoDictionary["CFBundleShortVersionString"] as? String {
				appVersionLabel.cell?.title = "Version: " + versionNumber
			}
		}
    }

	@IBAction private final func launchGitHubPage(_ sender: NSButton) {
		guard let urlAddress: URL = URL(string: "https://github.com/giulio92/NPOD-Downloader") else {
			return
		}

		NSWorkspace.shared().open(urlAddress)
	}
}
