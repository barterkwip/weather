//
//  WeatherDay.swift
//  WiproWeather
//
//  Created by bartek on 6/13/16.
//  Copyright © 2016 bartoszalksnin. All rights reserved.
//

import Foundation

class WeatherDay {
	let weatherForecastPoints: Array<WeatherForecastPoint>;

	let minTemperature: Int;
	let maxTemperature: Int;
	let date: NSDate;
	let humidity: Int;
	let description: String;
	let icon: String;

	init(weatherPoints: Array<WeatherForecastPoint>) {
		self.weatherForecastPoints = weatherPoints;
		var avgHumidity = 0;

		var maxTemperature = Int.min;
		var minTemperature = Int.max;
		for weatherPoint in weatherPoints {
			maxTemperature = max(weatherPoint.weatherStats.max, maxTemperature);
			minTemperature = min(weatherPoint.weatherStats.min, minTemperature);
			avgHumidity += weatherPoint.weatherStats.humidity;
		}

		let representativeWeatherPoint = WeatherDay.getRepresentativeWeatherPoint(weatherPoints);

		self.humidity = avgHumidity / weatherPoints.count;
		self.maxTemperature = maxTemperature;
		self.minTemperature = minTemperature;
		self.date = NSDate(timeIntervalSince1970: NSTimeInterval(weatherPoints[0].date));
		self.description = representativeWeatherPoint.getDescription();
		self.icon = representativeWeatherPoint.getIcon();
	}

	private static func getRepresentativeWeatherPoint(weatherPoints: Array<WeatherForecastPoint>) -> WeatherForecastPoint {
		for weatherPoint in weatherPoints {
			// here we would select weather type with highest % during the day, or highest priority (like extream events)
			// for now just select one of day points
			let date = NSDate(timeIntervalSince1970: NSTimeInterval(weatherPoint.date));
			let calendar = NSCalendar.currentCalendar();
			let hour = calendar.components(.Hour, fromDate: date)
			if (hour.hour > 12) {
				return weatherPoint;
			}
		}
		return weatherPoints[0];
	}
}