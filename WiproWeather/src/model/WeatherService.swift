//
//  File.swift
//  WiproWeather
//
//  Created by bartek on 6/13/16.
//  Copyright © 2016 bartoszalksnin. All rights reserved.
//

import Foundation
import CoreData

class WeatherCondition {
	let id: Int;
	let description: String;
	let icon: String;

	init(id: Int, description: String, icon: String) {
		self.id = id;
		self.description = description;
		self.icon = icon;
	}

	static func FromJson(json: NSDictionary?) -> WeatherCondition? {
		guard let id = json?["id"] as? Int else { return nil }
		guard let description = json?["description"] as? String else { return nil }
		guard let icon = json?["icon"] as? String else { return nil }

		return WeatherCondition(id: id, description: description, icon: icon);
	}
}

class WeatherStats {
	let min: Int;
	let max: Int;
	let humidity: Int;

	init(min: Int, max: Int, humidity: Int) {
		self.min = min;
		self.max = max;
		self.humidity = humidity;
	}

	static func FromJson(json: NSDictionary?) -> WeatherStats? {
		guard let mainStats = json?["main"] as? NSDictionary else { return nil }
		guard let minTemperature = mainStats["temp_min"] as? Int else { return nil }
		guard let maxTemperature = mainStats["temp_max"] as? Int else { return nil }
		guard let humidity = mainStats["humidity"] as? Int else { return nil }

		return WeatherStats(min: minTemperature, max: maxTemperature, humidity: humidity);
	}
}

class WeatherForecastPoint {

	let weatherConditions: Array<WeatherCondition>;
	let weatherStats: WeatherStats;
	let date: Int;

	init(weatherConditions: Array<WeatherCondition>, weatherStats: WeatherStats, date: Int) {
		self.weatherConditions = weatherConditions;
		self.weatherStats = weatherStats;
		self.date = date;
	}

	func getDescription() -> String {
		return weatherConditions[0].description;
	}

	func getIcon() -> String {
		return weatherConditions[0].icon;
	}

	static func FromJson(json: NSDictionary?) -> WeatherForecastPoint? {
		guard let weatherConditions = parseWeatherConditions(json) else { return nil };
		guard let weatherStats = WeatherStats.FromJson(json) else { return nil };
		guard let date = json?["dt"] as? Int else { return nil };

		return WeatherForecastPoint(weatherConditions: weatherConditions, weatherStats: weatherStats, date: date);
	}

	static func parseWeatherConditions(json: NSDictionary?) -> Array<WeatherCondition>? {
		guard let weatherConditionList = json?["weather"] as? NSArray else { return nil }

		let weatherConditions = weatherConditionList.map({ json -> WeatherCondition? in
			let item = WeatherCondition.FromJson(json as? NSDictionary)
			return item
			}
		).filter({ item in
			return item != nil
			}
		).map({ item in
			return item!
		})

		return weatherConditions;
	}
}

class WeatherForecast: BaseDto {
	let forecastPoints: Array<WeatherForecastPoint>;

	init(forecastPoints: Array<WeatherForecastPoint>) {
		self.forecastPoints = forecastPoints;
	}

	static func FromJson(json: NSDictionary?) -> BaseDto? {
		guard let forecastList = json?["list"] as? NSArray else { return nil }
		let forecastPoints = forecastList.map({ json -> WeatherForecastPoint? in
			let item = WeatherForecastPoint.FromJson(json as? NSDictionary)
			return item
			}
		).filter({ item in
			return item != nil
			}
		).map({ item in
			return item!
		})

		return WeatherForecast(forecastPoints: forecastPoints);
	}
}

class WeatherService: NetworkService<WeatherForecast> {
	convenience init() {
		self.init(methodName: "forecast");
	}

	override init(methodName: String) {
		super.init(methodName: methodName);
	}
}