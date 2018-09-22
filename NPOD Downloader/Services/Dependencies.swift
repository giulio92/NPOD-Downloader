//
//  Dependencies.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 22/09/18.
//  Copyright © 2018 Giulio Lombardo. All rights reserved.
//

protocol DependenciesProtocol: HasNetworkService {}

final class Dependencies: DependenciesProtocol {
    lazy var networkService: NetworkServiceProvider = NetworkService()
}
