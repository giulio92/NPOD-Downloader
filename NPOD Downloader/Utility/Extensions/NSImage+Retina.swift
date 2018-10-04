//
//  NSImage+Retina.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 03/10/2018.
//  Copyright © 2018 Giulio Lombardo. All rights reserved.
//

import AppKit

extension NSImage {
    var isRetina: Bool {
        guard let retinaDisplay: NSScreen = NSScreen.screens.first(where: { screen -> Bool in
            screen.backingScaleFactor >= 2
        }) else {
            return false
        }

        let requiredHeight: Bool = size.height >= (retinaDisplay.frame.height * 2)
        let requiredWidth: Bool = size.width >= (retinaDisplay.frame.width * 2)

        return requiredHeight && requiredWidth
    }
}
