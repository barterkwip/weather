//
//  Created by bartek on 3/19/16.
//  Copyright © 2016 bartoszalksnin. All rights reserved.
//

import UIKit

class WeatherDayCellView: UITableViewCell {
	@IBOutlet weak var dateText: UILabel!
	@IBOutlet weak var descriptionText: UILabel!
	@IBOutlet weak var maxTemperatureText: UILabel!
	@IBOutlet weak var minTemperatureText: UILabel!
	@IBOutlet weak var icon: UIImageView!

	func showDate(date: NSDate) {
		let format = NSDateFormatter();
		format.dateStyle = NSDateFormatterStyle.FullStyle;
		let dateString = format.stringFromDate(date)
		dateText!.text = dateString;
	}

	func showDescription(description: String) {
		descriptionText!.text = description;
	}

	func showTemperature(maxTemperature: Int, minTemperature: Int) {
		let celcius = "\u{00B0}C";
		maxTemperatureText!.text = String(maxTemperature) + celcius;
		minTemperatureText!.text = String(minTemperature) + celcius;
	}

	func showIcon(iconUrl: String) {
		downloadImage(iconUrl);
	}

	func downloadImage(urlString: String) {
		if let url = NSURL(string: urlString) {
			NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
				dispatch_async(dispatch_get_main_queue()) { () -> Void in
					guard let data = data where error == nil else { return }
					self.icon.image = UIImage(data: data)
				}
			}.resume()
		}
	}
}
