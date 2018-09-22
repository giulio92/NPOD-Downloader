//
//  UserDefaultsService.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 22/09/18.
//  Copyright © 2018 Giulio Lombardo. All rights reserved.
//

import Foundation

protocol HasUserDefaultsService: AnyObject {
	var userDefaultsService: UserDefaultsServiceProvider { get }
}

protocol UserDefaultsServiceProvider: AnyObject {

}

final class UserDefaultsService: UserDefaultsServiceProvider {
	private let userDefaults: UserDefaults

	init() {
		userDefaults = .standard
	}

	var keepImage: Bool {
		get {
			return userDefaults.bool(forKey: Constants.UserDefaultKeys.keepImage)
		} set {
			userDefaults.set(newValue, forKey: Constants.UserDefaultKeys.keepImage)
			synchronize()
		}
	}

	private func synchronize() {
		userDefaults.synchronize()
	}
}
