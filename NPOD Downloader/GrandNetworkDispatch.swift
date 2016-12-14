//
//  GrandNetworkDispatch.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 14/07/16.
//  Copyright © 2016 Giulio Lombardo. All rights reserved.
//

import Alamofire

class GrandNetworkDispatch {
	static func getUbernodes(_ success: @escaping (_ ubernodes: [[String : String]]) -> (), failure: @escaping (_ errorData: AnyObject) -> ()) {
		let ubernodesAPI: String = "https://www.nasa.gov/api/1/query/ubernodes.json?unType%5B%5D=image&routes%5B%5D=1446&page=0&pageSize=24"

		performGET(ubernodesAPI, success: {
			(data) in

			success(data["ubernodes"] as! [[String : String]])
			}, failure: {
				(errorData) in

				failure("" as AnyObject)
		})
	}

	static func getImageDetailsWithNodeID(_ nodeID: String, success: @escaping (_ imageDetails: [String: String]) -> (), failure: @escaping (_ errorData: AnyObject) -> ()) {
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

			if UserDefaults.standard.dictionary(forKey: "imageDatabase") != nil {
				var currentImageDatabase: [String : [String: String]] = UserDefaults.standard.dictionary(forKey: "imageDatabase") as! [String : [String: String]]
				currentImageDatabase[nodeID] = imageData[nodeID]

				UserDefaults.standard.set(currentImageDatabase, forKey: "imageDatabase")
			} else {
				UserDefaults.standard.set(imageData, forKey: "imageDatabase")
			}

			success(imageData[nodeID]!)
			}, failure: {
				(errorData) in

				failure("" as AnyObject)
		})
	}

	static func downloadImageWithData(_ imageData: [String: String], progressUpdate: @escaping (_ percentage: Double) -> (), success: @escaping (_ downloadedPath: URL) -> (), failure: (_ errorData: AnyObject) -> ()) {
		guard NetworkReachabilityManager()!.isReachable else {
			return failure("No internet connection" as AnyObject)
		}

		let fileManager: FileManager = FileManager.default
		let pictureDirectory: URL = fileManager.urls(for: .picturesDirectory, in: .userDomainMask).first!

		let imageName: String = imageData["filename"]!

		if fileManager.fileExists(atPath: pictureDirectory.path + "/" + imageName) {
			return success(pictureDirectory.appendingPathComponent(imageName))
		}

		var downloadPath: URL?

		let destination: DownloadRequest.DownloadFileDestination = {
			(temporaryURL, response) in

			downloadPath = pictureDirectory.appendingPathComponent(imageName)

			return (downloadPath!, [.removePreviousFile])
		}

		Alamofire.download(imageData["imageURL"]!, to: destination).downloadProgress {
			(progress) in

			progressUpdate(progress.fractionCompleted)
		}.responseData {
			(response) in

			success(downloadPath!)
		}
	}

	private static func performGET(_ requestURL: String, success: @escaping (_ data: [String : AnyObject]) -> (), failure: @escaping (_ errorData: AnyObject) -> ()) {
		guard NetworkReachabilityManager()!.isReachable else {
			return failure("No internet connection" as AnyObject)
		}

		Alamofire.request(requestURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseData() {
			(response) in

			#if DEBUG
				print(response.timeline)
			#endif

			guard response.response != nil else {
				return failure("" as AnyObject)
			}

			switch response.result {
			case .success:
				do {
					success(try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! [String : AnyObject])
				} catch (let error as NSError) {
					#if DEBUG
						print(error)
					#endif

					failure("" as AnyObject)
				}
				break

			case .failure(let error):
				#if DEBUG
					print(error)
				#endif

				failure("" as AnyObject)
				break
			}
		}
	}
	
	static func cancelAllRequests() {
		Alamofire.SessionManager.default.session.getTasksWithCompletionHandler {
			(sessionDataTask, uploadData, downloadData) in

			sessionDataTask.forEach {
				$0.cancel()
			}

			uploadData.forEach {
				$0.cancel()
			}

			downloadData.forEach {
				$0.cancel()
			}
		}
	}
}
