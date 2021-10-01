//
//  Cities.swift
//  Weather v1
//
//  Created by Максим on 18.07.2021.
//

import Foundation

protocol CitiesViewModel {
    
    //    MARK: - Properties
    var listCities: [String] { get }
    var listWithWeather: [String: Weather] { get }
    var countCities: Int { get }
    
    //    MARK: - Func
    func didTapAddCity(city: String)
    func didTapRemoveCity(at index: Int)
    func addWeather(city: String, weather: Weather)
}

class CitiesViewModelImpl: CitiesViewModel {
    
    static var shared: CitiesViewModel = CitiesViewModelImpl()
    
    var listCities: [String] { return cities }
    var listWithWeather: [String: Weather] { return  dictionaryOfCitiesWithWeather }
    var countCities: Int { return cities.count }
    
    private var cities: [String] = [
        "Иркутск",
        "Сочи",
        "Berlin",
        "Москва",
        "Мадрид",
        "Тверь",
        "Калининград",
        "Владиивосток",
        "Buenos Aires",
        "Омск"
    ]
    
    private var dictionaryOfCitiesWithWeather: [String: Weather] = [:]
    
    private init() {}
    
    func didTapAddCity(city: String) {
        cities.append(city.capitalized)
        
        //        if let index = cities.firstIndex(of: city) {
        //            cities.remove(at: index)
        //        }
    }
    
    func didTapRemoveCity(at index: Int) {
        
        let city = cities[index]
        cities.remove(at: index)
        dictionaryOfCitiesWithWeather[city] = nil
    }
    
    func addWeather(city: String, weather: Weather) {
        dictionaryOfCitiesWithWeather[city.capitalized] = weather
    }
}

