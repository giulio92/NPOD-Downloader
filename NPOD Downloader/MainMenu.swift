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
    private var nodeOfTheDay: Node? {
        didSet {
            guard let newValue: Node = nodeOfTheDay else {
                currentImageName.title = "Unknown"
                return
            }

            currentImageName.title = newValue.ubernode.title
        }
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

        currentImageName.title = "Retrieving image details..."

        dependencies.networkService.getNode(id: latestNode.id, completion: { result in
            switch result {
            case let .success(node):
                self.nodeOfTheDay = node
                self.downloadLatestImage()

            case let .failure(networkError):
                break
            }
        })
    }

    private func downloadLatestImage() {
        guard let image: Node.Image = nodeOfTheDay?.images.first else {
            return
        }

        dependencies.networkService.downloadImage(nodeImage: image, progressUpdate: { _ in

        }, completion: { result in
            switch result {
            case .success:
                break

            case let .failure(networkError):
                break
            }
        })
    }
}
