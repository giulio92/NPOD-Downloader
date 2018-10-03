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

    private let dependencies: Dependencies = Dependencies()

    private var currentImageIndex: Int = 0 {
        didSet {
            updateImage()
        }
    }

    @IBAction private func nextImageAction(_: NSButton) {
        increaseIndex()
    }

    @IBAction private func previousImageAction(_: NSButton) {
        decreaseIndex()
    }

    @IBAction private func keepImageAction(_: NSButton) {
        toggleKeepImageOption()
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        updateImage()
        configureKeepImageButton()
    }

    private func configureKeepImageButton() {
        if dependencies.userDefaultsService.keepImage {
            keepImageButton.state = .on
        } else {
            keepImageButton.state = .off
        }
    }

    private func toggleKeepImageOption() {
        dependencies.userDefaultsService.keepImage = !dependencies.userDefaultsService.keepImage
    }

    private func updateImage() {
        let newImage: NSImage = dependencies.fileManagerService.downloadedImages[currentImageIndex]

        imageView.image = newImage
        retinaBadgeIcon.isHidden = !newImage.isRetina
    }

    private func increaseIndex() {
        guard currentImageIndex < dependencies.fileManagerService.downloadedImages.count - 1 else {
            return
        }

        currentImageIndex += 1
    }

    private func decreaseIndex() {
        guard currentImageIndex > 0 else {
            return
        }

        currentImageIndex -= 1
    }
}
