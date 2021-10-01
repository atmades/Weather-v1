//
//  ViewController.swift
//  Weather v1
//
//  Created by Максим on 18.07.2021.
//


import UIKit

class CitiesViewController: UIViewController {
    
    //    MARK: - Properties
    var viewModel = CitiesViewModelImpl.shared
    
    // MARK: - Views
    private lazy var searchController = UISearchController(searchResultsController: nil)
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    @objc private func refresh(sender: UIRefreshControl) {
        sender.beginRefreshing()
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.refreshData()
        }
        sender.endRefreshing()
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(WeatherCell.self, forCellReuseIdentifier: WeatherCell.identifier)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Private Func
    private func refreshData() {
        let networkService: NetworkService = NetworkServiceImpl()
        viewModel.listCities.forEach { [weak self] city in
            guard let self = self else { return }
            networkService.getWeather(for: city) { result in
                switch result {
                case .success(let weather):
                    self.viewModel.addWeather(city: city, weather: weather)
                    self.tableView.reloadData()
                case .failure(let error):
                    print(type(of: self), #function, error.localizedDescription)
                }
            }
        }
    }
    
    private func setupLayout() {
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func setupNavController() {
        navigationItem.title = String.titlesVC.mainVC.rawValue
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()
        
        let colorTitle = UIColor(named: String.colors.black.rawValue)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: colorTitle ?? UIColor.black]
        
        let searchIcon = UIImage(systemName: "magnifyingglass")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        let searchButton = UIBarButtonItem(image: searchIcon, style: .plain, target: self, action: #selector(didTapSearchButton))
        
        navigationItem.rightBarButtonItems = [searchButton]
    }
    
    @objc func didTapSearchButton() {
        present(searchController, animated: true, completion: nil)
    }
    
    //  Fletch New City And ShowDetail
    private func showDetailWeatherFor(city: String) {
        
        if let weatherFromList = viewModel.listWithWeather[city] {
            DispatchQueue.main.async {
                let weatherForDetail: WeatherDetailInfo = (weather: weatherFromList, city: city, isExist: true)
                self.openDetail(weather: weatherForDetail)
            }
            return
        }
        let networkService: NetworkService = NetworkServiceImpl()
        print(networkService)
        networkService.getWeather(for: city) { [weak self] result in
            switch result {
            case .success(let weather):
                DispatchQueue.main.async {
                    let weatherForDetail: WeatherDetailInfo = (weather: weather, city: city, isExist: false)
                    self?.openDetail(weather: weatherForDetail)
                }
                
            case .failure(let error):
                print(type(of: self), #function, error.localizedDescription)
                Alert.showUknownLocation()
            }
        }
    }
    //  Create and Present DetailVC
    private func openDetail(weather: WeatherDetailInfo) {
        let detailVC = DetailWeatherViewController()
        detailVC.setWeather(detailWeatherInfo: weather)
        detailVC.delegate = self
        self.navigationController?.present(detailVC, animated: true)
    }
    
    // MARK: - Lifecycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavController()
        view.addSubview(tableView)

        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        searchController.searchBar.delegate = self
        
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.refreshData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}


// MARK: - Extension UITableViewDataSource
extension CitiesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.countCities
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCell.identifier, for: indexPath) as? WeatherCell else { return UITableViewCell() }
        
        let city = viewModel.listCities[indexPath.row]
        cell.city = city
        if let weather = viewModel.listWithWeather[city] {
            cell.weather = weather
        }
        return cell
    }
}

// MARK: - Extension UITableViewDelegate
extension CitiesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = viewModel.listCities[indexPath.row]
        if let weather = viewModel.listWithWeather[city] {
            let weatherForDetail: WeatherDetailInfo = (weather: weather, city: city, isExist: true)
            self.openDetail(weather: weatherForDetail)
//            self.openDetail(for: weather, and: city, isExist: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { _, _, complete in

            self.viewModel.didTapRemoveCity(at: indexPath.row)
            print(self.viewModel.listCities)
            print(self.viewModel.listWithWeather.count)
            tableView.deleteRows(at: [indexPath], with: .fade)
            complete(true)
        }

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
}

// MARK: - Extension UISearchBarDelegate
extension CitiesViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let city = searchBar.text?.capitalized, !city.isEmpty {
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                self.showDetailWeatherFor(city: city)
            }
            searchBar.text = nil
            dismiss(animated: true, completion: nil)
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
    }
}

// MARK:- EXTENSION AddNewWeatherDelegate
extension CitiesViewController: AddNewWeatherDelegate {
    func addNewWeather(city: String, weather: Weather) {
        self.dismiss(animated: true) {
            self.viewModel.didTapAddCity(city: city)
            self.viewModel.addWeather(city: city, weather: weather)
            self.tableView.reloadData()
        }
    }
}


