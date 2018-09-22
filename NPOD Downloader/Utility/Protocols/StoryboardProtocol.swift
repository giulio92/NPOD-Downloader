//
//  StoryboardProtocol.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 22/09/18.
//  Copyright © 2018 Giulio Lombardo. All rights reserved.
//

import AppKit

protocol StoryboardProtocol: AnyObject {
	static func initialize(from storyboard: NSStoryboard) -> Self
}

extension StoryboardProtocol where Self: NSViewController {
	static func initialize(from storyboard: NSStoryboard) -> Self {
		let nameSpaceClassName: String = NSStringFromClass(self)

		guard let className: String = nameSpaceClassName.components(separatedBy: ".").last else {
			fatalError(Constants.FatalErrors.nameSpaceError + nameSpaceClassName)
		}

		guard let viewController: Self = storyboard.instantiate(withIdentifier: className) as? Self else {
			fatalError(Constants.FatalErrors.storyboardError + className)
		}

		return viewController
	}
}
