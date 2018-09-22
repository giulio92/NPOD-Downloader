//
//  Node.swift
//  NPOD Downloader
//
//  Created by Lombardo Giulio on 22/09/18.
//  Copyright © 2018 Giulio Lombardo. All rights reserved.
//

struct Node: Decodable {
	struct Images: Decodable {
		let filename: String
		let timestamp: String
		let uuid: String
		let width: String
		let height: String
	}

	struct Ubernode: Decodable {
		let title: String
		let imageFeatureCaption: String
	}

	let images: [Images]
	let ubernode: Node.Ubernode
}
