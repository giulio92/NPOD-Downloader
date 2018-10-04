//
//  AboutController.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 22/09/18.
//  Copyright © 2018 Giulio Lombardo. All rights reserved.
//

import AppKit

final class AboutController: NSViewController, StoryboardProtocol {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        view.window?.styleMask.remove(.resizable)
    }
}
