//
//  WallpaperService.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 04/10/2018.
//  Copyright © 2018 Giulio Lombardo. All rights reserved.
//

import AppKit

protocol HasWallpaperService: AnyObject {
    var wallpaperService: WallpaperServiceProvider { get }
}

protocol WallpaperServiceProvider: AnyObject {}

final class WallpaperService: WallpaperServiceProvider {
    typealias Dependencies = HasFileManagerService

    private var dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func setWallpaper(imageName: String) throws {
        do {
            let fileURL: URL = try dependencies.fileManagerService.downloadDirectory(filename: imageName)
            let image: NSImage = NSImage(byReferencing: fileURL)

            try NSScreen.screens.forEach({ screen in
                let options: [NSWorkspace.DesktopImageOptionKey: Any] = [:]

                try NSWorkspace.shared.setDesktopImageURL(fileURL, for: screen, options: options)
            })

        } catch let error {
            throw error
        }
    }
}
