//
//  DetailViewModel.swift
//  Weather v1
//
//  Created by Максим on 18.07.2021.
//

import Foundation

protocol DetailViewModel {
    var detailInfo: (WeatherDetailInfo)? { get }
    func setDetailInfo(weather: WeatherDetailInfo)
}

class DetailViewModelImpl: DetailViewModel {
    var detailInfo: (WeatherDetailInfo)?
    
    func setDetailInfo(weather: WeatherDetailInfo) {
        detailInfo = weather
    } 
}
