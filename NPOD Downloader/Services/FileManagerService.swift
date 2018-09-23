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
    var downloadedImages: [URL] { get }

    func downloadDirectory(filename: String) throws -> URL
    func imageAlreadyDownloaded(imageName: String) -> Bool
}

final class FileManagerService: FileManagerServiceProvider {
    private enum FileManagerServiceError: Error {
        case noPicturesFolder
    }

    private let fileManager: FileManager

    init() {
        fileManager = .default
    }

    private func applicationFolder() throws -> URL {
        guard let picturesDirectory: URL = fileManager.urls(for: .picturesDirectory, in: .userDomainMask).first else {
            throw FileManagerServiceError.noPicturesFolder
        }

        let applicationDirectory: URL = picturesDirectory.appendingPathComponent(Constants.applicationName)

        guard fileManager.fileExists(atPath: applicationDirectory.path) == false else {
            return applicationDirectory
        }

        do {
            try fileManager.createDirectory(at: applicationDirectory, withIntermediateDirectories: false, attributes: nil)
            return applicationDirectory
        } catch let error {
            throw error
        }
    }

    var downloadedImages: [URL] {
        do {
            let filenames: [String] = try fileManager.contentsOfDirectory(atPath: applicationFolder().path)

            return try filenames.filter({ filename -> Bool in
                filename.hasSuffix(Constants.ImageExtensions.jpg) ||
                    filename.hasSuffix(Constants.ImageExtensions.jpeg) ||
                    filename.hasSuffix(Constants.ImageExtensions.png)
            }).map({ filename -> URL in
                try downloadDirectory(filename: filename)
            })
        } catch _ {
            return []
        }
    }

    func downloadDirectory(filename: String) throws -> URL {
        do {
            return try applicationFolder().appendingPathComponent(filename)
        } catch let error {
            throw error
        }
    }

    func imageAlreadyDownloaded(imageName: String) -> Bool {
        do {
            return try fileManager.fileExists(atPath: downloadDirectory(filename: imageName).path)
        } catch _ {
            return false
        }
    }
}
