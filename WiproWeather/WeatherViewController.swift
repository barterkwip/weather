//
//  WeatherViewController.swift
//  WiproWeather
//
//  Created by bartek on 6/13/16.
//  Copyright © 2016 bartoszalksnin. All rights reserved.
//

import UIKit

class WeatherViewController: UITableViewController {

	private let context = Context();
	private let callbackKey = "WeatherViewControlelr";

	override func viewDidLoad() {
		super.viewDidLoad()

		context.getWeatherModel().addCallback(callbackKey, callback: weatherUpdatedCallback);
//		self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
	}

	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		context.getWeatherModel().removeCallback(callbackKey);
	}

	func weatherUpdatedCallback() {
		dispatch_async(dispatch_get_main_queue()) {
			self.tableView.reloadData()
		}
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	}

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return context.getWeatherModel().getWeatherDayCount()
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("DayCell", forIndexPath: indexPath)
		self.configureCell(cell as! WeatherDayCellView, atIndexPath: indexPath)
		return cell
	}

	func configureCell(cell: WeatherDayCellView, atIndexPath indexPath: NSIndexPath) {
		let format = NSDateFormatter();
		format.dateStyle = NSDateFormatterStyle.FullStyle;

		if let weatherDay = context.getWeatherModel().getWeatherDayAt(indexPath.row) {
			let dateString = format.stringFromDate(weatherDay.date)
			cell.dateText!.text = dateString;
			cell.descriptionText!.text = weatherDay.description;
			cell.maxTemperatureText!.text = String(weatherDay.maxTemperature);
			cell.minTemperatureText!.text = String(weatherDay.minTemperature);
		}
	}
}
