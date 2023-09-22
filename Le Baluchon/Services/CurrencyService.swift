//
//  CurrencyService.swift
//  Le Baluchon
//
//  Created by Melvin Poutrel on 08/06/2023.
//

import Foundation

protocol CurrencyServiceProtocol {
    func getCurrencyCodes(completion: @escaping ([String : String]) -> Void)
    func convert(amount: Double, country: String, completion: @escaping (Double?) -> Void)
    func getRatesWithAPI(completion: @escaping ([String: Double]?) -> Void)
    var delegate: CurrencyServiceDelegate? { get set }
}

protocol CurrencyServiceDelegate: AnyObject {
    func currencyDataDidUpdate()
}

class CurrencyServiceImplementation: CurrencyServiceProtocol {
    var delegate: CurrencyServiceDelegate?
    
    // MARK: - Properties
    private let accessKey: String
    private let baseURL: String
    let urlSession: any URLSessionProtocol
    
    let currencyBase = "EUR"
    var currencyCode = "USD"
    var exchangeRate = Double()
    
    var symbols = [String: String]()
    var rates = [String: Double]()
    
    var timestamp = Int()
    
    
    // MARK: - Initializer
    init(urlSession: any URLSessionProtocol = URLSession(configuration: .default)) {
        self.urlSession = urlSession
        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
              let keys = NSDictionary(contentsOfFile: path),
              let accessKey = keys["FixerApiKey"] as? String,
              let baseURL = keys["FixerApiURL"] as? String else {
            fatalError("Unable to read keys from Keys.plist")
        }
        self.accessKey = accessKey
        self.baseURL = baseURL
        getCurrencyCodes { [weak self] symbols in
            self?.symbols = symbols
            self?.delegate?.currencyDataDidUpdate()
            self?.getRatesWithAPI { rates in
                self?.rates = rates ?? [:]
            }
            self?.delegate?.currencyDataDidUpdate()
        }
    }
    
    // MARK: - Methods
    
    func getCurrencyCodes(completion: @escaping ([String: String]) -> Void) {
        if !self.symbols.isEmpty {
            completion(self.symbols)
            return
        }
        
        getCurrencyCodesWithAPI { [weak self] result in
            switch result {
            case .success(let symbols):
                self?.symbols = symbols
                completion(symbols)
            case .failure(let error):
                print("Error fetching currency codes: \(error)")
                completion([:])
            }
        }
    }

    func convert(amount: Double, country: String, completion: @escaping (Double?) -> Void) {
        self.currencyCode = country
        
        if self.timestamp != 0, Date().timeIntervalSince1970 - Double(self.timestamp) < 86400 {
            let exchangeRate = self.rates[country] ?? 0
            let result = amount * exchangeRate
            let roundedResult = Double(round(100 * result) / 100)
            completion(roundedResult)
        } else {
            convertWithAPI(amount: amount) { result in
                switch result {
                case .success(let rate):
                    completion(rate)
                case .failure( _):
                    completion(nil)
                }
            }
        }
    }
    
    func convertWithAPI(amount: Double, completion: @escaping (Result<Double, Error>) -> Void) {
        let url = "\(baseURL)convert?to=\(currencyCode)&from=\(currencyBase)&amount=\(amount)"
        guard let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let apiURL = URL(string: encodedURL) else {
            completion(.failure(CurrencyError.invalidURL))
            return
        }
        
        var request = URLRequest(url: apiURL, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.addValue(accessKey, forHTTPHeaderField: "apikey")
        
        let task = self.urlSession.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let jsonData = data else {
                completion(.failure(CurrencyError.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(CurrencyConversionResponse.self, from: jsonData)
                
                let result = response.result
                let timestamp = response.info.timestamp
                let rate = response.info.rate
                
                self?.timestamp = timestamp
                self?.exchangeRate = rate
                
                let roundedResult = Double(round(100 * result) / 100)
                completion(.success(roundedResult))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    
    func getCurrencyCodesWithAPI(completion: @escaping (Result<[String: String], Error>) -> Void) {
            let url = "\(baseURL)symbols"
            var request = URLRequest(url: URL(string: url)!, timeoutInterval: Double.infinity)
            request.httpMethod = "GET"
            request.addValue(accessKey, forHTTPHeaderField: "apikey")
            
            let task = self.urlSession.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(CurrencyError.invalidData))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(CurrencySymbolResponse.self, from: data)
                    completion(.success(response.symbols))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
        
        func getRatesWithAPI(completion: @escaping ([String: Double]?) -> Void) {
            if !self.rates.isEmpty {
                completion(self.rates)
                return
            }
            
            let currencyCodes = symbols.keys.joined(separator: ",")
            let url = "\(baseURL)latest?symbols=\(currencyCodes)&base=\(currencyBase)"
            
            guard let apiURL = URL(string: url) else {
                print("Invalid URL: \(url)")
                completion(nil)
                return
            }
            
            var request = URLRequest(url: apiURL, timeoutInterval: Double.infinity)
            request.httpMethod = "GET"
            request.addValue(accessKey, forHTTPHeaderField: "apikey")
            
            let task = self.urlSession.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                    completion(nil)
                    return
                }
                
                guard let jsonData = data else {
                    print("No data received")
                    completion(nil)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(CurrencyRatesResponse.self, from: jsonData)
                    
                    self.timestamp = response.timestamp
                    self.rates = response.rates
                    
                    completion(response.rates)
                } catch {
                    print("Error parsing JSON or extracting rate value: \(error)")
                    completion(nil)
                }
            }
            task.resume()
        }
}
