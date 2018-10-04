//
//  Result.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 22/09/18.
//  Copyright © 2018 Giulio Lombardo. All rights reserved.
//

enum Result<T, E> {
    case success(T)
    case failure(E)
}
