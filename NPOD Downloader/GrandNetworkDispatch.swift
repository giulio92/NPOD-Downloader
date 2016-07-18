//
//  GrandNetworkDispatch.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 14/07/16.
//  Copyright © 2016 Giulio Lombardo. All rights reserved.
//

import Alamofire

class GrandNetworkDispatch {
	class func getUbernodesWithURL(requestURL: String, success: (data: Array<Dictionary<String, String>>) -> Void, failure: (errorData: AnyObject) -> Void) {
		performGET(requestURL, success: {
			(data) in

			success(data: data["ubernodes"] as! Array<Dictionary<String, String>>)
			}, failure: {
				(errorData) in
				failure(errorData: "")
		})
	}

	class func getImageDetailsWithNodeURL(nodeURL: String, success: (data: Dictionary<String, String>) -> Void, failure: (errorData: AnyObject) -> Void) {
		performGET(nodeURL, success: {
			(data) in

			let imageInformations: Dictionary<String, AnyObject> = data["ubernode"] as! Dictionary<String, AnyObject>
			let title: String = imageInformations["title"] as! String
			let description: String = imageInformations["imageFeatureCaption"] as! String

			let imagesContainer: Array<Dictionary<String, AnyObject>> = data["images"] as! Array<Dictionary<String, AnyObject>>
			let images: Dictionary<String, AnyObject> = imagesContainer.first!
			let filename: String = images["filename"] as! String

			success(data: [
				"title": title,
				"description": description,
				"url": "https://www.nasa.gov/sites/default/files/thumbnails/image/" + filename
				])
			}, failure: {
				(errorData) in
				failure(errorData: "")
		})
	}

	class func downloadImage(imageURL: String, progressUpdate: (percentage: Float) -> Void, success: (downloadedPath: NSURL) -> Void, failure: (errorData: AnyObject) -> Void) {
		guard NetworkReachabilityManager()!.isReachable else {
			return failure(errorData: "")
		}

		Alamofire.download(.GET, imageURL, destination: Alamofire.Request.suggestedDownloadDestination(directory: .PicturesDirectory, domain: .UserDomainMask)).progress {
			(bytesRead, totalBytesRead, totalBytesExpectedToRead) in

			// This closure is NOT called on the main queue for performance
			// reasons. To update your UI, dispatch to the main queue.
			dispatch_async(dispatch_get_main_queue(), {
				progressUpdate(percentage: Float(totalBytesRead/totalBytesExpectedToRead))
			})
			}.response {
				(request, response, data, error) in

				success(downloadedPath: NSFileManager.defaultManager().URLsForDirectory(.PicturesDirectory, inDomains: .UserDomainMask).first!.URLByAppendingPathComponent(response!.suggestedFilename!))
		}
	}

	private class func performGET(requestURL: String, success: (data: Dictionary<String, AnyObject>) -> Void, failure: (errorData: AnyObject) -> Void) {
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
					success(data: try NSJSONSerialization.JSONObjectWithData(response.data!, options: .MutableContainers) as! Dictionary<String, AnyObject>)
				} catch let error as NSError {
					failure(errorData: "")
				}
				break

			case .Failure(let error):
				failure(errorData: "")
				break
			}
		}
	}

	class func cancelAllRequests() {

	}
}