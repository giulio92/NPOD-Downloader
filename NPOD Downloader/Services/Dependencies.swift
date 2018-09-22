//
//  Dependencies.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 22/09/18.
//  Copyright © 2018 Giulio Lombardo. All rights reserved.
//

protocol DependenciesProtocol: HasNetworkService, HasFileManagerService, HasUserDefaultsService {}

final class Dependencies: DependenciesProtocol {
    lazy var fileManagerService: FileManagerServiceProvider = FileManagerService()
    lazy var networkService: NetworkServiceProvider = NetworkService(dependencies: self)
    lazy var userDefaultsService: UserDefaultsServiceProvider = UserDefaultsService()
}
