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
	let humidity: Int;

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

		self.humidity = avgHumidity / weatherPoints.count;
		self.maxTemperature = maxTemperature;
		self.minTemperature = minTemperature;
	}
}