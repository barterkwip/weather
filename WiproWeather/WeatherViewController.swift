//
//  WeatherViewController.swift
//  WiproWeather
//
//  Created by bartek on 6/13/16.
//  Copyright © 2016 bartoszalksnin. All rights reserved.
//

import UIKit

class WeatherViewController: UITableViewController {

	private let weather = WeatherService();

	override func viewDidLoad() {
		super.viewDidLoad()

		weather.fetchData() {
			dispatch_async(dispatch_get_main_queue()) {
				self.tableView.reloadData()
			}
		};

//		self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
	}

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
	}

	override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return weather.getData()?.getForecastCount() ?? 0
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("DayCell", forIndexPath: indexPath)
		self.configureCell(cell as! WeatherDayCellView, atIndexPath: indexPath)
		return cell
	}

	func configureCell(cell: WeatherDayCellView, atIndexPath indexPath: NSIndexPath) {
		cell.nameText!.text = weather.getData()?.getForecast()?.getDescription();
	}
}
