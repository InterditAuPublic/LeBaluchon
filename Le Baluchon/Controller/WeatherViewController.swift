//
//  WeatherViewController.swift
//  Le Baluchon
//
//  Created by Melvin Poutrel on 04/05/2023.
//

import Foundation
import UIKit

class WeatherViewController: UIViewController, UIScrollViewDelegate {

    // MARK: - Properties
    private let weatherService = WeatherServiceImplementation()
     let city1View = CityWeatherReusableView(city: "Paris")
     let city2View = CityWeatherReusableView(city: "New York")


    // MARK: - Outlets
    
    @IBOutlet weak var cityWeatherContainer: UIScrollView!
    @IBOutlet weak var weatherLabel: UINavigationItem!
    
    // MARK: - View Life Cycle
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }

    private var pageControl: UIPageControl!

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    // MARK: - Methods
    
    private func prepareView() {
        
        pageControl = UIPageControl()
                pageControl.numberOfPages = 2
                pageControl.currentPageIndicatorTintColor = .white
                pageControl.pageIndicatorTintColor = .gray
                pageControl.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(pageControl)
               
                NSLayoutConstraint.activate([
                    pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                    pageControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                    pageControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                    pageControl.heightAnchor.constraint(equalToConstant: 50)
                ])

        cityWeatherContainer.contentSize = CGSize(width: cityWeatherContainer.frame.size.width * 2, height: cityWeatherContainer.frame.size.height)

        cityWeatherContainer.isPagingEnabled = true
        cityWeatherContainer.isScrollEnabled = true

        cityWeatherContainer.showsHorizontalScrollIndicator = false
        cityWeatherContainer.showsVerticalScrollIndicator = false

        cityWeatherContainer.delegate = self
        
        city1View.cityReusableView.frame = CGRect(x: 0, y: 0, width: cityWeatherContainer.frame.size.width, height: cityWeatherContainer.frame.size.height)
        
        city2View.cityReusableView.frame = CGRect(x: cityWeatherContainer.frame.size.width, y: 0, width: cityWeatherContainer.frame.size.width, height: cityWeatherContainer.frame.size.height)
         
        city1View.cityReusableView.backgroundColor = .lightGray
        city2View.cityReusableView.backgroundColor = .lightGray

        cityWeatherContainer.addSubview(city1View.cityReusableView)
        cityWeatherContainer.addSubview(city2View.cityReusableView)
        
        weatherLabel.title = "Weather"
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
pageControl.currentPage = currentPage
    }
    
    func cityWeatherViewDidEncounterError() {
            let alertController = UIAlertController(title: "Erreur Réseau", message: "Une erreur réseau s'est produite. Veuillez vérifier votre connexion Internet et réessayer.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
}
