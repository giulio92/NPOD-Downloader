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

			let detailsContainer: [[String : AnyObject]] = data["images"] as! [[String : AnyObject]]
			let details: [String : AnyObject] = detailsContainer.first!
			let filename: String = details["filename"] as! String
			let thumbnailURL: String = details["crop4x3ratio"] as! String

			let imageData: [String: [String: String]] = [
				nodeID: [
					"title": title,
					"description": description,
					"filename": filename,
					"imageURL": baseURL + "/sites/default/files/thumbnails/image/" + filename,
					"thumbnailURL": baseURL + thumbnailURL
				]
			]

			if NSUserDefaults.standardUserDefaults().dictionaryForKey("imageDatabase") != nil {
				var currentImageDatabase: [String : [String: String]] = NSUserDefaults.standardUserDefaults().dictionaryForKey("imageDatabase") as! [String : [String: String]]
				currentImageDatabase[nodeID] = imageData[nodeID]

				NSUserDefaults.standardUserDefaults().setObject(currentImageDatabase, forKey: "imageDatabase")
			} else {
				NSUserDefaults.standardUserDefaults().setObject(imageData, forKey: "imageDatabase")
			}

			success(imageDetails: imageData[nodeID]!)
			}, failure: {
				(errorData) in

				failure(errorData: "")
		})
	}

	class func downloadImageWithData(imageData: [String: String], progressUpdate: ((percentage: Float) -> Void)?, success: (downloadedPath: NSURL) -> Void, failure: (errorData: AnyObject) -> Void) {
		guard NetworkReachabilityManager()!.isReachable else {
			return failure(errorData: "No internet connection")
		}

		let fileManager: NSFileManager = NSFileManager.defaultManager()
		let pictureDirectory: NSURL = fileManager.URLsForDirectory(.PicturesDirectory, inDomains: .UserDomainMask).first!

		let imageName: String = imageData["filename"]!

		if fileManager.fileExistsAtPath(pictureDirectory.path! + "/" + imageName) {
			return success(downloadedPath: pictureDirectory.URLByAppendingPathComponent(imageName))
		}

		var downloadPath: NSURL?

		Alamofire.download(.GET, imageData["imageURL"]!, destination: {
			(temporaryURL, response) in

			downloadPath = pictureDirectory.URLByAppendingPathComponent(imageName)

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
			return failure(errorData: "No internet connection")
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
		Alamofire.Manager.sharedInstance.session.getTasksWithCompletionHandler {
			(dataTasks, uploadTasks, downloadTasks) in

			dataTasks.forEach({
				(task) in
				task.cancel()
			})

			uploadTasks.forEach({
				(task) in
				task.cancel()
			})

			downloadTasks.forEach({
				(task) in
				task.cancel()
			})
		}
	}
}