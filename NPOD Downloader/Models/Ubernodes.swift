//
//  Ubernodes.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 22/09/18.
//  Copyright © 2018 Giulio Lombardo. All rights reserved.
//

struct Ubernodes: Decodable {
    struct Ubernode: Decodable {
        let type: String
        let promoDateTime: String
        let nid: String
    }

    let ubernodes: [Ubernode]
}
