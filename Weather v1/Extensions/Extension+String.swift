//
//  Extension+String.swift
//  Weather v1
//
//  Created by Максим on 18.07.2021.
//

import Foundation

extension String {
    
    enum titlesVC: String {
        case mainVC = "Погода"
    }
    
    enum button: String {
        case addWeather = "Добавить в список"
    }
    
    enum identifiers: String {
        case weatherCell = "WeatherCell"
    }
    
    enum interface: String {
        case ok = "Ok"
        case delete = "Удалить"
        case addWeather = "Добавить в список"
    }
    
    enum urlComponents: String {
        case scheme = "https"
        case host = "api.weather.yandex.ru"
        case path = "/v2/forecast"
        case latitude = "latitude"
        case longitude = "longitude"
        case headerForKey = "X-Yandex-API-Key"
    }
    
    enum urlComponentsImage: String {
        case scheme = "https"
        case host = "images7.alphacoders.com"
        case path = "/671/671281.jpg"
        case all = "https://images7.alphacoders.com/671/671281.jpg"
    }
    
    
    
    enum alertCityNotFound: String {
        case tittle = "По вашему запросу ничего не нашлось"
        case message = "Попробуйте поискать что-то другое."
    }
    
    enum colors: String {
        case black = "black"
        case gradientStart = "bgStart"
        case gradientMiddle = "gradientMiddle"
        case gradientEnd = "bgEnd"
        case blue = "blue"
    }
    
    enum icons: String {
        case chevronRight = "chevronRight"
    }
    
    enum  weather: String {
        case temp = "℃"
        case feelsLike = "По ощущениям"
        case windSpeed = "Скорость ветра"
        case windSpeedDegree = "м/с"
        case pressure = "Атм. Давление"
        case pressureDegree = "мм.рт.ст."
        case humidity = "Влажность"
        case humidityDegree = "%"
    }
    
    enum imagesWeather: String {
        case partlyCloudy = "partly-cloudy"
    }
}


