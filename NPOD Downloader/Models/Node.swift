//
//  Node.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 22/09/18.
//  Copyright © 2018 Giulio Lombardo. All rights reserved.
//

import Foundation

struct Node: Decodable {
	struct Image: Decodable {
		private enum CodingKeys: String, CodingKey {
			case filename
			case timestamp
			case uniqueID = "uuid"
			case width
			case height
		}

		let filename: String
		let timestamp: String
		let uniqueID: String
		private let width: String
		private let height: String

		var size: CGSize {
			let formatter: NumberFormatter = NumberFormatter()

			guard let width: NSNumber = formatter.number(from: width), let height: NSNumber = formatter.number(from: height) else {
				return .zero
			}

			return CGSize(width: CGFloat(width.floatValue), height: CGFloat(height.floatValue))
		}
	}

	struct Ubernode: Decodable {
		let title: String
		let imageFeatureCaption: String
	}

	let images: [Image]
	let ubernode: Node.Ubernode
}
