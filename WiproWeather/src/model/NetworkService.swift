//
//
//  Created by bartek on 3/20/16.
//  Copyright © 2016 bartoszalksnin. All rights reserved.
//

import Foundation
import CoreData

protocol BaseDto {
	static func FromJson(json: NSDictionary?) -> BaseDto?;
}

class NetworkService<Dto: BaseDto> {

	private let appId = "1600977d1fd4b8a16dcadf6c428a547b";
	private let location = "London,uk";
	private let url = "http://api.openweathermap.org/data/2.5/"

	private let methodName: String;

	private var data: Dto?

	private var callbacks: [String: () -> Void] = [:];

	init(methodName: String) {
		self.methodName = methodName;
	}

	func addCallback(key: String, callback: () -> Void) {
		callbacks[key] = callback
	}

	func removeCallback(key: String, callback: () -> Void) {
		callbacks.removeValueForKey(key)
	}

	func fetchData(callback: (() -> Void)? = nil) {
		let path = url + methodName + String(format: "?q=%@&appid=%@", location, appId);

		NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: path)!) { data, response, error in
			if let result = data {
				do {
					let json = try NSJSONSerialization.JSONObjectWithData(result, options: NSJSONReadingOptions(rawValue: 0))
					guard let jsonArray = json as? NSDictionary else {
						print("Fetch requests returned not an Dictionary")
						return
					}
					self.parseJson(jsonArray);
					callback?();
				}
				catch let error as NSError {
					print("\(error)")
				}
			}
		}.resume()
	}

	func callRefreshCallbacks() {
		for (_, value) in callbacks {
			value()
		}
	}

	func parseJson(jsonDictionary: NSDictionary) {
		let dto = Dto.FromJson(jsonDictionary)
		updateItems(dto as? Dto)
	}

	func updateItems(data: Dto?) {
		self.data = data;
		self.callRefreshCallbacks();
	}

	func getData() -> Dto? {
		return data;
	}
}