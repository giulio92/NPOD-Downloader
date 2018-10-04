//
//  FileManagerService.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 22/09/18.
//  Copyright © 2018 Giulio Lombardo. All rights reserved.
//

import AppKit
import Foundation

protocol HasFileManagerService: AnyObject {
    var fileManagerService: FileManagerServiceProvider { get }
}

protocol FileManagerServiceProvider: AnyObject {
    var downloadedImagePaths: [URL] { get }
    var downloadedImages: [NSImage] { get }

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

    var downloadedImagePaths: [URL] {
        do {
            let filenames: [URL] = try fileManager.contentsOfDirectory(at: applicationFolder(),
                                                                       includingPropertiesForKeys: [.creationDateKey],
                                                                       options: .skipsHiddenFiles)

            return try filenames.sorted(by: { lhURL, rhURL -> Bool in
                let lhValues: URLResourceValues = try lhURL.resourceValues(forKeys: [.creationDateKey])

                guard let lhDate: Date = lhValues.creationDate else {
                    return false
                }

                let rhValues: URLResourceValues = try rhURL.resourceValues(forKeys: [.creationDateKey])

                guard let rhDate: Date = rhValues.creationDate else {
                    return false
                }

                return lhDate > rhDate
            })
        } catch _ {
            return []
        }
    }

    var downloadedImages: [NSImage] {
        return downloadedImagePaths.compactMap({ fileURL -> NSImage? in
            NSImage(byReferencing: fileURL)
        })
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
