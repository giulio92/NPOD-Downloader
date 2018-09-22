//
//  FileManagerService.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 22/09/18.
//  Copyright © 2018 Giulio Lombardo. All rights reserved.
//

import Foundation

protocol HasFileManagerService: AnyObject {
	var fileManagerService: FileManagerServiceProvider { get }
}

protocol FileManagerServiceProvider: AnyObject {
	func directoriesURL(searchPath: FileManager.SearchPathDirectory) -> [URL]
	func fileExists(fileName: String, path: URL) -> Bool
}

final class FileManagerService: FileManagerServiceProvider {
	private let fileManager: FileManager

	init() {
		fileManager = .default
	}

	func directoriesURL(searchPath: FileManager.SearchPathDirectory) -> [URL] {
		return fileManager.urls(for: searchPath, in: .userDomainMask)
	}

	func fileExists(fileName: String, path: URL) -> Bool {
		return fileManager.fileExists(atPath: path.path + "/" + fileName)
	}
}
