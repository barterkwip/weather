//
//  WeatherModel.swift
//  WiproWeather
//
//  Created by bartek on 6/13/16.
//  Copyright © 2016 bartoszalksnin. All rights reserved.
//

import Foundation

class WeatherModel {

	private let weatherService: WeatherService;
	private var weatherDays = Array<WeatherDay>();
	private var dataRefreshCallbacks: [String: () -> Void] = [:];

	private let location = "London,uk";

	init(weatherService: WeatherService) {
		self.weatherService = weatherService;

		weatherService.fetchData("&units=metric&q=\(location)") {
			self.updateModel();
			self.notifyCallbacks();
		}
	}

	func addCallback(key: String, callback: () -> Void) {
		self.dataRefreshCallbacks[key] = callback
	}

	func removeCallback(key: String) {
		self.dataRefreshCallbacks.removeValueForKey(key)
	}

	func notifyCallbacks() {
		for (_, callback) in self.dataRefreshCallbacks {
			callback();
		}
	}

	func updateModel() {
		var forecastPointsByDay = Dictionary<Int, Array<WeatherForecastPoint>>();

		for forecastPoint in weatherService.getData()?.forecastPoints ?? [] {
			let date = forecastPoint.date;

			let calendar = NSCalendar.currentCalendar();
			let day = calendar.ordinalityOfUnit(.Day, inUnit: .Year, forDate: date)
			if forecastPointsByDay[day] != nil {
				forecastPointsByDay[day]?.append(forecastPoint)
			}
			else {
				forecastPointsByDay[day] = [forecastPoint];
			}
		}

		for (_, forecastPoints) in forecastPointsByDay {
			let weather = WeatherDay(weatherPoints: forecastPoints);
			weatherDays.append(weather);
		}

		weatherDays.sortInPlace() { (weatherDayA, weatherDayB) -> Bool in
			return weatherDayA.date.compare(weatherDayB.date) == NSComparisonResult.OrderedAscending
		}
	}

	func getWeatherDayCount() -> Int {
		return weatherDays.count;
	}

	func getWeatherDayAt(index: Int) -> WeatherDay? {
		if (index < weatherDays.count) {
			return weatherDays[index];
		}
		return nil;
	}
}