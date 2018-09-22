//
//  UserDefaultsService.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 22/09/18.
//  Copyright © 2018 Giulio Lombardo. All rights reserved.
//

import Cocoa

protocol HasUserDefaultsService: AnyObject {
	var userDefaultsService: UserDefaultsServiceProvider { get }
}

protocol UserDefaultsServiceProvider: AnyObject {

}

final class UserDefaultsService: UserDefaultsServiceProvider {

}
