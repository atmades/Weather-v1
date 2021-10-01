//
//  DetailWeatherViewController.swift
//  Weather v1
//
//  Created by Максим on 18.07.2021.
//

import Foundation
import UIKit

protocol AddNewWeatherDelegate: AnyObject {
    func addNewWeather(city:String, weather: Weather)
}

final class DetailWeatherViewController: UIViewController {
    
    //    MARK: - Properties
    var viewModel: DetailViewModelImpl = DetailViewModelImpl()
    var delegate: AddNewWeatherDelegate?
    let aspectRatio: CGFloat = 180/255
    let imageDataSerice: ImageDataService = ImageDataServiceImpl()
    
    //    MARK: - Views
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var cityNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .light)
        label.textColor = UIColor(named: String.colors.black.rawValue)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "??"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var tempLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 100, weight: .light)
        label.textColor = UIColor(named: String.colors.black.rawValue)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.text = "??"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var tempFeelsLikeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(named: String.colors.black.rawValue)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.text = "??"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var viewForImage: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }() //  Contains WeatherImageView and ActivityIndicator
    
    var weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.turnOn()
        return indicator
    }()
    
    var conditionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.textColor = UIColor(named: String.colors.black.rawValue)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.text = "??"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var divider: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var detailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }() // Contains WindLabel + PressureLabel + humidityLabel
    
    var windLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(named: String.colors.black.rawValue)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.text = "??"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var pressureLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(named: String.colors.black.rawValue)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.text = "??"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var humidityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(named: String.colors.black.rawValue)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.text = "??"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //    Button
    var bgForButton: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: String.colors.gradientMiddle.rawValue)
        view.addBlur(style: .systemChromeMaterial)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }() // Contains addWeatherButton
    
    var addWeatherButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(named: String.colors.blue.rawValue)
        button.layer.cornerRadius = 6
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        button.setTitle(String.interface.addWeather.rawValue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        return button
    }()
    
    @objc func didTapSave() {
        guard let weather = viewModel.detailInfo else { return }
        delegate?.addNewWeather(city: weather.city, weather: weather.weather)
    }
    
    //    MARK: - Private func
    private func setupUI() {
        self.weatherImageView.isHidden = true
        guard let detailWeatherInfo = viewModel.detailInfo else { return }
        let city = detailWeatherInfo.city
        let weather = detailWeatherInfo.weather
        let isExist = detailWeatherInfo.isExist
        isExist ? (bgForButton.isHidden = true) : (bgForButton.isHidden = false)
        
        let convertService = WeatherConvertService()
        
        let temp = weather.fact.temp
        let condition = weather.fact.condition
        let feelsLikeTemp = weather.fact.feelsLike
        let windSpeed = weather.fact.windSpeed
        let windDirection = convertService.setWindDirection(wind: weather.fact.windDirection)
        let pressure = weather.fact.pressure
        let humidity = weather.fact.humidity
        
        imageDataSerice.downloadImage(condition: weather.fact.condition) { image in
            self.activityIndicator.turnOff()
            self.weatherImageView.image = image
            self.weatherImageView.isHidden = false
        }
        
        cityNameLabel.text = city
        tempLabel.text = convertService.setTemp(temp: temp)
        conditionLabel.text = convertService.setCondition(condition: condition)
        tempFeelsLikeLabel.text = convertService.setFeelsLikeTemp(temp: feelsLikeTemp)
        windLabel.text = convertService.setWind(speed: windSpeed, direction: windDirection)
        pressureLabel.text = convertService.setPressure(pressure: pressure)
        humidityLabel.text = convertService.setHumidity(humidity: humidity)
    }
//    Add all views
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        view.addSubview(bgForButton)
        bgForButton.addSubview(addWeatherButton)
        
        [cityNameLabel,
         tempLabel,
         tempFeelsLikeLabel,
         viewForImage,
         conditionLabel,
         divider,
         detailStackView
        ].forEach {
            contentView.addSubview($0)
        }
        
        detailStackView.addArrangedSubview(windLabel)
        detailStackView.addArrangedSubview(pressureLabel)
        detailStackView.addArrangedSubview(humidityLabel)
        
        viewForImage.addSubview(weatherImageView)
        viewForImage.addSubview(activityIndicator)
    }
    
    //    Constraints of Main Views
    private func setupLoyautViews() {
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bgForButton.topAnchor).isActive = true
        
        
        bgForButton.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bgForButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bgForButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bgForButton.heightAnchor.constraint(equalToConstant: 108).isActive = true
        
        addWeatherButton.topAnchor.constraint(equalTo: bgForButton.topAnchor, constant: 8).isActive = true
        addWeatherButton.trailingAnchor.constraint(equalTo: bgForButton.trailingAnchor, constant: -Constants.offset).isActive = true
        addWeatherButton.leadingAnchor.constraint(equalTo: bgForButton.leadingAnchor, constant: Constants.offset).isActive = true
        addWeatherButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
    }
    
    //    Constraints views in ScrollView
    private func setupLoyautScrollViews() {
        
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        cityNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.offset).isActive = true
        cityNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 54).isActive = true
        cityNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.offset).isActive = true
        
        tempLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.offset).isActive = true
        tempLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 8).isActive = true
        tempLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.offset).isActive = true
        
        tempFeelsLikeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.offset).isActive = true
        tempFeelsLikeLabel.topAnchor.constraint(equalTo: tempLabel.bottomAnchor, constant: 0).isActive = true
        tempFeelsLikeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.offset).isActive = true
        
        viewForImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 60).isActive = true
        viewForImage.topAnchor.constraint(equalTo: tempFeelsLikeLabel.bottomAnchor, constant: 0).isActive = true
        viewForImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60).isActive = true
        viewForImage.heightAnchor.constraint(equalTo: viewForImage.widthAnchor, multiplier: aspectRatio).isActive = true
        
        
        conditionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.offset).isActive = true
        conditionLabel.topAnchor.constraint(equalTo: viewForImage.bottomAnchor, constant: 8).isActive = true
        conditionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.offset).isActive = true
        
        divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.offset).isActive = true
        divider.topAnchor.constraint(equalTo: conditionLabel.bottomAnchor, constant: 32).isActive = true
        divider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.offset).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        detailStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.offset).isActive = true
        detailStackView.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 32).isActive = true
        detailStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.offset).isActive = true
        detailStackView.heightAnchor.constraint(equalToConstant: 88).isActive = true
        detailStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -80).isActive = true
        
        weatherImageView.trailingAnchor.constraint(equalTo: viewForImage.trailingAnchor).isActive = true
        weatherImageView.leadingAnchor.constraint(equalTo: viewForImage.leadingAnchor).isActive = true
        weatherImageView.topAnchor.constraint(equalTo: viewForImage.topAnchor).isActive = true
        weatherImageView.bottomAnchor.constraint(equalTo: viewForImage.bottomAnchor).isActive = true
        
        activityIndicator.centerYAnchor.constraint(equalTo: viewForImage.centerYAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: viewForImage.centerXAnchor).isActive = true
    }
    
    //    MARK: - Public Func
    public func setWeather(detailWeatherInfo: WeatherDetailInfo) {
        viewModel.setDetailInfo(weather: detailWeatherInfo)
    }
    
    //    MARK: - LifeCycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLoyautViews()
        setupLoyautScrollViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: String.colors.gradientMiddle.rawValue)
        addSubviews()
        setupUI()
    }
    
    deinit {
        print("deinit detail")
    }
}
