//
//  GrandNetworkDispatch.swift
//  NPOD Downloader
//
//  Created by Giulio Lombardo on 24/05/16.
//  Copyright © 2016 Giulio Lombardo. All rights reserved.
//

import Cocoa
import Alamofire

class GrandNetworkDispatch {
	class func performGET(requestURL: String, success: (data: NSData) -> Void, failure: (errorData: AnyObject) -> Void) {
		guard NetworkReachabilityManager()!.isReachable else {
			return
		}

		Alamofire.request(.GET, requestURL, parameters: nil, encoding: .JSON, headers: nil).validate().responseData() {
			response in

			switch response.result {
			case .Success:
				success(data: response.data!)
				break

			case .Failure(let error):
				break
			}
		}
	}
}