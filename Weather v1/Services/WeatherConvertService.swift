//
//  WeatherConvertService.swift
//  Weather v1
//
//  Created by Максим on 16.08.2021.
//

import Foundation

final class WeatherConvertService {
    
    func setTemp(temp: Int) -> String {
        let сelsius = String.weather.temp.rawValue
        return temp > 0 ? "+\(temp)\(сelsius)" : "\(temp)\(сelsius)"
    }
    
    func setFeelsLikeTemp(temp: Int) -> String {
        let feels = String.weather.feelsLike.rawValue
        return temp > 0 ? "\(feels) +\(temp)" : "\(feels) -\(temp)"
    }
    
    func setWind(speed: Double, direction: String) -> String {
        let windSpeed = String.weather.windSpeed.rawValue
        let windSpeedDegree = String.weather.windSpeedDegree.rawValue
        return "\(windSpeed): \(speed) \(windSpeedDegree), \(direction)"
    }
    
    func setPressure(pressure: Int) -> String {
        let pressureName = String.weather.pressure.rawValue
        let pressureDegree = String.weather.pressureDegree.rawValue
        return pressureName + " \(pressure) " + pressureDegree
    }
    
    func setHumidity(humidity: Int) -> String {
        let humidityName = String.weather.humidity.rawValue
        let humidityDegree = String.weather.humidityDegree.rawValue
        
        return humidityName + " \(humidity)" + humidityDegree
    }
    
    func setCondition(condition: String) -> String {
        switch condition {
        case "clear":
            return "ясно"
        case "partly-cloudy":
            return "малооблачно"
        case "cloudy":
            return "облачно с прояснениями"
        case "overcast":
            return "пасмурно"
        case "drizzle":
            return "морось"
        case "light-rain":
            return "небольшой дождь"
        case "rain":
            return "дождь"
        case "moderate-rain":
            return "умеренно сильный дождь"
        case "heavy-rain":
            return "сильный дождь"
        case "continuous-heavy-rain":
            return "длительный сильный дождь"
        case "showers":
            return "ливень"
        case "wet-snow":
            return "дождь со снегом"
        case "light-snow":
            return "небольшой снег"
        case "snow":
            return "снег"
        case "snow-showers":
            return "снегопад"
        case "hail":
            return "град"
        case "thunderstorm":
            return "гроза"
        case "thunderstorm-with-rain":
            return "дождь с грозой"
        case "thunderstorm-with-hail":
            return "гроза с градом"
        default:
            return ""
        }
    }
    
    func setWindDirection(wind: String) -> String {
        switch wind {
        case "nw":
            return "С/З"
        case "n":
            return "С"
        case "ne":
            return "С/В"
        case "e":
            return "В"
        case "se":
            return "Ю/В"
        case "s":
            return "Ю"
        case "sw":
            return "С/З"
        case "w":
            return "В"
        default:
            return ""
        }
    }
}



