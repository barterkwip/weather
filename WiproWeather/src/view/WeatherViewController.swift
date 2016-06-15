//
//  WeatherViewController.swift
//  WiproWeather
//
//  Created by bartek on 6/13/16.
//  Copyright © 2016 bartoszalksnin. All rights reserved.
//

import UIKit

class WeatherViewController: UITableViewController {

	private static let CALLBACK_KEY = "WeatherViewControlelr";
	private static let TABLE_VIEW_CELL = "DayCell"

	private let context = Context();

	override func viewDidLoad() {
		super.viewDidLoad()

		context.getWeatherModel().addCallback(WeatherViewController.CALLBACK_KEY, callback: weatherUpdatedCallback);

		tableView.tableFooterView = UIView()
		self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
	}

	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		context.getWeatherModel().removeCallback(WeatherViewController.CALLBACK_KEY);
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
		let cell = tableView.dequeueReusableCellWithIdentifier(WeatherViewController.TABLE_VIEW_CELL, forIndexPath: indexPath)
		self.configureCell(cell as! WeatherDayCellView, atIndexPath: indexPath)
		return cell
	}

	func configureCell(cell: WeatherDayCellView, atIndexPath indexPath: NSIndexPath) {
		if let weatherDay = context.getWeatherModel().getWeatherDayAt(indexPath.row) {
			cell.showDate(weatherDay.date);
			cell.showDescription(weatherDay.description);
			cell.showTemperature(weatherDay.maxTemperature, minTemperature: weatherDay.minTemperature)
			cell.showIcon(weatherDay.iconUrl)
		}
	}
}
