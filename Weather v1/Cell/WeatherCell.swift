//
//  WeatherCell.swift
//  Weather v1
//
//  Created by Максим on 18.07.2021.
//

import UIKit


class WeatherCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = String.identifiers.weatherCell.rawValue
    
    
    var city: String? {
        didSet {
            guard let city = city else { return }
            setupViews(for: city)
        }
    }
    
    var weather: Weather? {
        didSet {
            guard let city = city else { return }
            setupViews(for: city)
        }
    }
    
    // MARK: - Views
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .light)
        label.textColor = UIColor(named: String.colors.black.rawValue)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textColor = UIColor(named: String.colors.black.rawValue)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let conditionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textColor = UIColor(named: String.colors.black.rawValue)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let rightStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let dataStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let iconChevronRight: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: String.icons.chevronRight.rawValue)?.withRenderingMode(.alwaysOriginal)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.turnOn()
        return indicator
    }()
    
    // MARK: - Private Func
    private func setupViews(for city: String) {
        cityLabel.text = city
        
        // Information display
        guard let weather = weather else { return }
        activityIndicator.turnOff()
        let convertService = WeatherConvertService()
        
        let temp = weather.fact.temp
        let condition = weather.fact.condition
        conditionLabel.text = convertService.setCondition(condition: condition)
        tempLabel.text = convertService.setTemp(temp: temp)
        tempLabel.isHidden = false
    }
    
    private func setupLayout() {
        mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        iconChevronRight.heightAnchor.constraint(equalToConstant: 20).isActive = true
        iconChevronRight.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    // MARK: - Init and Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        contentView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(cityLabel)
        mainStackView.addArrangedSubview(activityIndicator)
        mainStackView.addArrangedSubview(rightStackView)
        
        rightStackView.addArrangedSubview(dataStackView)
        rightStackView.addArrangedSubview(iconChevronRight)
        dataStackView.addArrangedSubview(tempLabel)
        dataStackView.addArrangedSubview(conditionLabel)
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayout()
    }
}

