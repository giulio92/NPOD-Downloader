//
//  NSStoryboard+NSViewController.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 22/09/18.
//  Copyright © 2018 Giulio Lombardo. All rights reserved.
//

import AppKit

extension NSStoryboard {
    func instantiate(withIdentifier identifier: String) -> NSViewController {
        let sceneIdentifier: NSStoryboard.SceneIdentifier = NSStoryboard.SceneIdentifier(rawValue: identifier)

        guard let viewController: NSViewController = instantiateController(withIdentifier: sceneIdentifier) as? NSViewController else {
            fatalError(Constants.FatalErrors.storyboardError + className)
        }

        return viewController
    }
}
