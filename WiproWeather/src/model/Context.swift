//
//  Context.swift
//  WiproWeather
//
//  Created by bartek on 6/14/16.
//  Copyright © 2016 bartoszalksnin. All rights reserved.
//

import Foundation

class Context {
	private let weatherService: WeatherService;
	private let weatherModel: WeatherModel;

	init() {
		weatherService = WeatherService();
		weatherModel = WeatherModel(weatherService: weatherService);
	}

	func getWeatherModel() -> WeatherModel {
		return weatherModel;
	}
}