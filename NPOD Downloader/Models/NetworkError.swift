//
//  NetworkError.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 22/09/18.
//  Copyright © 2018 Giulio Lombardo. All rights reserved.
//

enum NetworkError: Int {
    case unreachable = 000
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case conflict = 409
    case unknown = 999

    init(rawValue: Int) {
        switch rawValue {
        case 000:
            self = .unreachable

        case 401:
            self = .unauthorized

        case 403:
            self = .forbidden

        case 404:
            self = .notFound

        case 409:
            self = .conflict

        case 999:
            self = .unknown

        default:
            self = .unknown
        }
    }
}
