//
//  Constants.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 22/09/18.
//  Copyright © 2018 Giulio Lombardo. All rights reserved.
//

import Foundation

enum Constants {
    static var bundleID: String {
        guard let identifier: String = Bundle.main.bundleIdentifier else {
            fatalError("Cannot find bundle identifier")
        }

        return identifier
    }

    static var applicationName: String {
        guard let name: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String else {
            fatalError("Cannot find CFBundleName")
        }

        return name
    }

    static var applicationVersion: String {
        guard let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            fatalError("Cannot find CFBundleShortVersionString")
        }

        return version
    }

    static var applicationBuild: String {
        guard let build: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String else {
            fatalError("Cannot find CFBundleVersion")
        }

        return build
    }

    static let gitHubPageURL: String = "https://github.com/giulio92/NPOD-Downloader"

    enum Nasa {
        private static let domain: String = "https://www.nasa.gov"
        private static let version: String = "1"
        static let API: String = domain + "/api/" + version

        static func ubernodes() -> String {
            return API + "/query/ubernodes.json?unType%5B%5D=image&routes%5B%5D=1446&page=0&pageSize=24"
        }

        static func nodeURL(id: String) -> String {
            return API + "/record/node/" + id + ".json"
        }

        static func imageURL(name: String) -> String {
            return domain + "/sites/default/files/thumbnails/image/" + name
        }
    }

    enum UserDefaultKeys {
        static let keepImage: String = "keepImage"
    }

    enum FatalErrors {
        static let nameSpaceError: String = "Cannot find class name from: "
        static let storyboardError: String = "Cannot find NSViewController with identifier: "
    }
}
