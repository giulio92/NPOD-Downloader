//
//  MainMenu.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 22/09/18.
//  Copyright © 2018 Giulio Lombardo. All rights reserved.
//

import AppKit

final class MainMenu: NSObject {
    @IBOutlet private var applicationMenu: NSMenu!
    @IBOutlet private var currentImageName: NSMenuItem!

    private let dependencies: Dependencies = Dependencies()
    private let storyboard: NSStoryboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)

    private let statusItem: NSStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

    private var currentNodes: [Ubernodes.Ubernode] = []

    @IBAction private func preferencesAction(_: NSMenuItem) {
        showSettingsController()
    }

    @IBAction private func aboutAction(_: NSMenuItem) {
        showAboutController()
    }

    @IBAction private func quitAction(_: NSMenuItem) {
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
                self.currentNodes = ubernodes.nodes
                self.getLatestNodeInformations()

            case let .failure(networkError):
                break
            }
        })
    }

    private func getLatestNodeInformations() {
        guard let latestNode: Ubernodes.Ubernode = currentNodes.first else {
            return
        }

        dependencies.networkService.getNode(id: latestNode.id, completion: { result in
            switch result {
            case let .success(node):
                break

            case let .failure(networkError):
                break
            }
        })
    }

    private func showSettingsController() {
        let viewController: SettingsController = SettingsController.initialize(from: storyboard)

        presentViewController(viewController: viewController)
    }

    private func showAboutController() {
        let viewController: AboutController = AboutController.initialize(from: storyboard)

        presentViewController(viewController: viewController)
    }

    private func presentViewController(viewController: NSViewController) {
        let window: NSWindow = NSWindow(contentViewController: viewController)
        window.makeKeyAndOrderFront(self)

        let windowController: NSWindowController = NSWindowController(window: window)
        windowController.showWindow(self)
    }
}
