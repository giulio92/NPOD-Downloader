//
//  MainMenu.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 22/09/18.
//  Copyright © 2018 Giulio Lombardo. All rights reserved.
//

import Cocoa

final class MainMenu: NSObject {
    @IBOutlet private weak var applicationMenu: NSMenu!
    @IBOutlet private weak var currentImageName: NSMenuItem!

    private let dependencies: Dependencies = Dependencies()

    private let statusItem: NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    @IBAction private func preferencesAction(_ sender: NSMenuItem) {

    }

    @IBAction private func aboutAction(_ sender: NSMenuItem) {

    }

    @IBAction private func quitAction(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        configureStatusItem()

        getUbernodes()
    }

    private func configureStatusItem() {
        statusItem.image = NSImage(named: NSImage.Name("MenuIcon"))
        statusItem.menu = applicationMenu
    }

    private func getUbernodes() {
        currentImageName.title = "Connecting to NASA..."

        dependencies.networkService.getUbernodes(completion: { result in
            switch result {
            case let .success(ubernodes):
                break

            case let .failure(networkError):
                break
            }
        })
    }
}
