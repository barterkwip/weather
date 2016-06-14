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
	private var weatherDays: Array<WeatherDay>
	private var callbacks: [String: () -> Void] = [:];

	private let location = "London,uk"

	init(weatherService: WeatherService, callback: (() -> Void)? = nil) {
		self.weatherService = weatherService;
		self.weatherDays = Array<WeatherDay>();

		weatherService.fetchData("&units=metric&q=\(location)") {
			self.updateModel();
			for (_, callback) in self.callbacks {
				callback();
			}
		}
	}

	func addCallback(key: String, callback: () -> Void) {
		self.callbacks[key] = callback
	}

	func removeCallback(key: String) {
		self.callbacks.removeValueForKey(key)
	}

	func updateModel() {
		var forecastPointsByDay = Dictionary<Int, Array<WeatherForecastPoint>>();

		for forecastPoint in weatherService.getData()?.forecastPoints ?? [] {
			let date = NSDate(timeIntervalSince1970: NSTimeInterval(forecastPoint.date))

			let calendar = NSCalendar.currentCalendar()
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