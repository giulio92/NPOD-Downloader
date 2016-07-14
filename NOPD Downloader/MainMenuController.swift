//
//  MainMenuController.swift
//  NOPD Downloader
//
//  Created by Giulio Lombardo on 14/07/16.
//  Copyright © 2016 Giulio Lombardo. All rights reserved.
//

import Cocoa

class MainMenuController: NSObject {
	@IBOutlet weak var applicationMenu: NSMenu!

	let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)

	override func awakeFromNib() {
		statusItem.image = NSImage(named: "MenuIcon")
		statusItem.menu = applicationMenu
	}

	@IBAction func aboutAction(sender: NSMenuItem) {

	}

	@IBAction func quitAction(sender: NSMenuItem) {
		NSApplication.sharedApplication().terminate(self)
	}
}