//
//  CurrencyService.swift
//  Le Baluchon
//
//  Created by Melvin Poutrel on 08/06/2023.
//

import Foundation

protocol CurrencyService {
    func getCurrencyCodes(completion: @escaping ([String : String]) -> Void)
    func convert(amount: Double, country: String, completion: @escaping (Double?) -> Void)
    func getRatesWithAPI(completion: @escaping ([String: Double]?) -> Void)
}

class CurrencyServiceImplementation: CurrencyService {

    // MARK: - Properties
    private let accessKey: String
    private let baseURL: String

    var symbols = [String: String]()
    let currencyBase = "EUR"
    var currencyCode = "USD"
    var exchangeRate = Double()
    var rates = [String: Double]()
    var timestamp = Int()

    
    // MARK: - Initializer
    init() {
        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
              let keys = NSDictionary(contentsOfFile: path),
              let accessKey = keys["FixerApiKey"] as? String,
              let baseURL = keys["FixerApiURL"] as? String else {
            fatalError("Unable to read keys from Keys.plist")
        }
        self.accessKey = accessKey
        self.baseURL = baseURL

        getCurrencyCodes(completion: { _ in })
        getRatesWithAPI(completion: { _ in })
    }
    
    // MARK: - Methods
    
    func getCurrencyCodes(completion: @escaping ([String : String]) -> Void) {
        print("getCurrencyCodes")
        if self.symbols.isEmpty {
            print("getCurrencyCodesWithAPI")
            getCurrencyCodesWithAPI()
        }
        completion(self.symbols)
    }
    
    func getCurrencyCodesWithAPI() {
        let url = "\(baseURL)symbols"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.addValue(accessKey, forHTTPHeaderField: "apikey")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("no data")
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            let symbols = json["symbols"] as! [String: String]
            self.symbols = symbols
            print("Symbols: \(symbols)")

        }
        task.resume()
    }
    
    func convert(amount: Double, country: String, completion: @escaping (Double?) -> Void) {
        if (self.timestamp != 0 && Date().timeIntervalSince1970 - Double(self.timestamp) < 86400) {
            print("SELF")
            let exchangeRate = self.rates[country] ?? 0
            print(exchangeRate)
            var result = amount * exchangeRate
            result = Double(round(100*result)/100)
            completion(result)
        } else {
            print("API")
            return convertWithAPI(amount: amount, completion: completion)
        }
        print(timestamp)
    }
    
    func convertWithAPI(amount: Double, completion: @escaping (Double?) -> Void) {
        let url = "\(baseURL)convert?to=\(currencyCode)&from=\(currencyBase)&amount=\(amount)"
        guard let encodedURL = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let apiURL = URL(string: encodedURL) else {
            print("Invalid URL: \(url)")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: apiURL, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.addValue(accessKey, forHTTPHeaderField: "apikey")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }
            guard let jsonResponse = data else {
                completion(nil)
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: jsonResponse, options: []) as? [String: Any],
                  let result = json["result"] as? Double,
                  let info = json["info"] as? [String: Any],
                  let timestamp = info["timestamp"] as? Int,
                  let rate = info["rate"] as? Double else {
                print("Error parsing JSON or extracting rate value")
                completion(nil)
                return
            }
            
            self.timestamp = timestamp
            self.exchangeRate = rate
            
            print(String(data: jsonResponse, encoding: .utf8)!)
            let roundedResult = Double(round(100*result)/100)
            completion(roundedResult)
        }
        task.resume()
    }

    
    func getExchangeRate(fromCurrency: String, toCurrency: String, completion: @escaping (Double?) -> Void) {
        let url = "\(baseURL)latest?symbols=\(toCurrency)&base=\(fromCurrency)"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.addValue(accessKey, forHTTPHeaderField: "apikey")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }
            guard let jsonResponse = data else {
                print("No data received")
                completion(nil)
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: jsonResponse, options: []) as? [String: Any],
                  let rates = json["rates"] as? [String: Double] else {
                print("Error parsing JSON or extracting rate value")
                completion(nil)
                return
            }
            
            let exchangeRate = rates[toCurrency]
            completion(exchangeRate)
        }
        task.resume()
    }

     func getRatesWithAPI(completion: @escaping ([String: Double]?) -> Void) {
        if self.rates.isEmpty {
            var currencyCode = [String].self()
            for (key, _) in symbols {
                currencyCode.append(key)
            }
            let currencyCodes = currencyCode.joined(separator: ",")
            
            let url = "\(baseURL)latest?symbols=\(currencyCodes)&base=\(currencyBase)"
            var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
            request.httpMethod = "GET"
            request.addValue(accessKey, forHTTPHeaderField: "apikey")
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                
                guard let jsonResponse = data else {
                    print("No data received")
                    completion(nil)
                    return
                }
                
                guard let json = try? JSONSerialization.jsonObject(with: jsonResponse, options: []) as? [String: Any],
                      let rates = json["rates"] as? [String: Double],
                      let info = json["info"] as? [String: Any],
                      let timestamp = info["timestamp"] as? Int
                      
                else {
                    completion(nil)
                    return
                }
                
                self.timestamp = timestamp
                self.rates = rates

                completion(rates)
            }
            task.resume()
        }
    }
}
