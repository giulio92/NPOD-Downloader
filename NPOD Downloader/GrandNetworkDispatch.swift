//
//  GrandNetworkDispatch.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 14/07/16.
//  Copyright © 2016 Giulio Lombardo. All rights reserved.
//

import Alamofire

class GrandNetworkDispatch {
	class func getUbernodes(success: (ubernodes: [[String : String]]) -> Void, failure: (errorData: AnyObject) -> Void) {
		let ubernodesAPI: String = "https://www.nasa.gov/api/1/query/ubernodes.json?unType%5B%5D=image&routes%5B%5D=1446&page=0&pageSize=24"

		performGET(ubernodesAPI, success: {
			(data) in

			success(ubernodes: data["ubernodes"] as! [[String : String]])
			}, failure: {
				(errorData) in

				failure(errorData: "")
		})
	}

	class func getImageDetailsWithNodeID(nodeID: String, success: (imageDetails: [String: String]) -> Void, failure: (errorData: AnyObject) -> Void) {
		let baseURL: String = "https://www.nasa.gov"
		let nodeURL: String = baseURL + "/api/1/record/node/" + nodeID + ".json"

		performGET(nodeURL, success: {
			(data) in

			let imageInformations: [String : AnyObject] = data["ubernode"] as! [String : AnyObject]
			let title: String = imageInformations["title"] as! String
			let description: String = imageInformations["imageFeatureCaption"] as! String

			let imagesContainer: [[String : AnyObject]] = data["images"] as! [[String : AnyObject]]
			let images: [String : AnyObject] = imagesContainer.first!
			let filename: String = images["filename"] as! String
			let thumbnailURL: String = images["crop4x3ratio"] as! String

			success(imageDetails: [
				"title": title,
				"description": description,
				"imageURL": baseURL + "/sites/default/files/thumbnails/image/" + filename,
				"thumbnailURL": baseURL + thumbnailURL
				])
			}, failure: {
				(errorData) in

				failure(errorData: "")
		})
	}

	class func downloadImage(imageURL: String, progressUpdate: ((percentage: Float) -> Void)?, success: (downloadedPath: NSURL) -> Void, failure: (errorData: AnyObject) -> Void) {
		guard NetworkReachabilityManager()!.isReachable else {
			return failure(errorData: "")
		}

		var downloadPath: NSURL?

		Alamofire.download(.GET, imageURL, destination: {
			(temporaryURL, response) in

			downloadPath = NSFileManager.defaultManager().URLsForDirectory(.PicturesDirectory, inDomains: .UserDomainMask).first!.URLByAppendingPathComponent(response.suggestedFilename!)

			return downloadPath!
		}).progress {
			(bytesRead, totalBytesRead, totalBytesExpectedToRead) in

			// This closure is NOT called on the main queue for performance
			// reasons. To update your UI, dispatch to the main queue.
			dispatch_async(dispatch_get_main_queue(), {
				progressUpdate?(percentage: Float(totalBytesRead/totalBytesExpectedToRead))
			})
			}.response {
				(request, response, data, error) in

				success(downloadedPath: downloadPath!)
		}
	}

	private class func performGET(requestURL: String, success: (data: [String : AnyObject]) -> Void, failure: (errorData: AnyObject) -> Void) {
		guard NetworkReachabilityManager()!.isReachable else {
			return failure(errorData: "")
		}

		Alamofire.request(.GET, requestURL, parameters: nil, encoding: .JSON, headers: nil).validate().responseData() {
			(response) in

			#if DEBUG
				print(response.timeline)
			#endif

			guard response.response != nil else {
				return failure(errorData: "")
			}

			switch response.result {
			case .Success:
				do {
					success(data: try NSJSONSerialization.JSONObjectWithData(response.data!, options: .MutableContainers) as! [String : AnyObject])
				} catch (let error as NSError) {
					#if DEBUG
						print(error)
					#endif

					failure(errorData: "")
				}
				break

			case .Failure(let error):
				#if DEBUG
					print(error)
				#endif

				failure(errorData: "")
				break
			}
		}
	}
	
	class func cancelAllRequests() {
		
	}
}