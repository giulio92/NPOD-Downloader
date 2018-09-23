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
    func downloadDirectory(filename: String) -> URL?
    func imageAlreadyDownloaded(imageName: String) -> Bool
}

final class FileManagerService: FileManagerServiceProvider {
    private let fileManager: FileManager

    init() {
        fileManager = .default
    }

    func downloadDirectory(filename: String) -> URL? {
        let picturesDirectory: URL? = fileManager.urls(for: .picturesDirectory, in: .userDomainMask).first

        return picturesDirectory?.appendingPathComponent(filename)
    }

    func imageAlreadyDownloaded(imageName: String) -> Bool {
        guard let downloadDirectory: URL = downloadDirectory(filename: imageName) else {
            return false
        }

        return fileManager.fileExists(atPath: downloadDirectory.path)
    }
}
