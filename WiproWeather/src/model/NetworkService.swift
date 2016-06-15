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
	private let url = "http://api.openweathermap.org/data/2.5/"

	private let methodName: String;
	private var data: Dto?

	init(methodName: String) {
		self.methodName = methodName;
	}

	func fetchData(options: String = "", fetchCompleteCallback: (() -> Void)? = nil) {
		let path = url + methodName + "?appid=\(appId)" + options;

		NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: path)!) { data, response, error in
			if let result = data {
				do {
					let json = try NSJSONSerialization.JSONObjectWithData(result, options: NSJSONReadingOptions(rawValue: 0))
					guard let jsonArray = json as? NSDictionary else {
						print("Fetch requests returned not an Dictionary")
						return
					}
					self.parseJson(jsonArray);
					fetchCompleteCallback?();
				}
				catch let error as NSError {
					print("\(error)")
				}
			}
		}.resume()
	}

	func parseJson(jsonDictionary: NSDictionary) {
		self.data = Dto.FromJson(jsonDictionary) as? Dto;
	}

	func getData() -> Dto? {
		return data;
	}
}