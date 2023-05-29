//
//  WeatherViewController.swift
//  Le Baluchon
//
//  Created by Melvin Poutrel on 04/05/2023.
//

import Foundation
import UIKit

class WeatherViewController: UIViewController, UIScrollViewDelegate {
    private let weatherService = WeatherServiceImplementation()
    let city1View = CityWeatherReusableView(city: "Paris")
    let city2View = CityWeatherReusableView(city: "New York")
    
    @IBOutlet weak var cityWeatherContainer: UIScrollView!
    @IBOutlet weak var weatherLabel: UINavigationItem!
    @IBOutlet weak var safeArea: UIView!
    
    // MARK: - View Life Cycle
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    private var scrollView: UIScrollView!
    private var pageControl: UIPageControl!
    
    private func prepareView() {
        scrollView = UIScrollView(frame: safeArea.bounds)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width * 2, height: scrollView.frame.size.height)
        scrollView.delegate = self
        
        pageControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        pageControl.numberOfPages = 2
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = .gray

        pageControl.center = CGPoint(x: scrollView.frame.size.width / 2, y: scrollView.frame.size.height - 50)
        

       
        
        city1View.cityReusableView.frame = CGRect(x: 0, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        city1View.cityReusableView.backgroundColor = .red
        
        city2View.cityReusableView.frame = CGRect(x: scrollView.frame.size.width, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
        city2View.cityReusableView.backgroundColor = .yellow
        
        scrollView.addSubview(city1View.cityReusableView)
        scrollView.addSubview(city2View.cityReusableView)
        
        cityWeatherContainer.addSubview(scrollView)
        cityWeatherContainer.addSubview(pageControl)
        
        weatherLabel.title = "Weather"
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
        pageControl.currentPage = currentPage
    }
}
