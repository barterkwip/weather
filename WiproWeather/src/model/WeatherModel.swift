//
//  WeatherModel.swift
//  WiproWeather
//
//  Created by bartek on 6/13/16.
//  Copyright © 2016 bartoszalksnin. All rights reserved.
//

import Foundation

class WeatherModel {

	let weatherService: WeatherService;
	private var weatherDays: Array<WeatherDay>

	init(weatherService: WeatherService, callback: (() -> Void)? = nil) {
		self.weatherService = weatherService;
		self.weatherDays = Array<WeatherDay>();

		weatherService.fetchData() {
			self.updateModel();
			callback?();
		}
	}

	func updateModel() {
		var forecastPointsByDay = Dictionary<Int, Array<WeatherForecastPoint>>();

		for forecastPoint in weatherService.getData()?.forecastPoints ?? [] {
			let date = NSDate(timeIntervalSince1970: NSTimeInterval(forecastPoint.date))

			let calendar = NSCalendar.currentCalendar()
			let day = calendar.ordinalityOfUnit(.Day, inUnit: .Year, forDate: date)
			if var points = forecastPointsByDay[day] {
				points.append(forecastPoint)
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
}