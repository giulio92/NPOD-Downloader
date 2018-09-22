//
//  AboutView.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 22/09/18.
//  Copyright © 2018 Giulio Lombardo. All rights reserved.
//

import AppKit

final class AboutView: NSView {
    @IBOutlet private weak var appVersionLabel: NSTextField!

    @IBAction private func forkAction(_ sender: NSButton) {
        openProjectPage()
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }

    private func openProjectPage() {
        guard let urlAddress: URL = URL(string: Constants.gitHubPageURL) else {
            return
        }

        NSWorkspace.shared.open(urlAddress)
    }
}
