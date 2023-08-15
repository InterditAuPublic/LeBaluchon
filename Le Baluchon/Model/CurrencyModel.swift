//
//  CurrencyConverter.swift
//  Le Baluchon
//
//  Created by Melvin Poutrel on 04/05/2023.
//

import Foundation

struct CurrencySymbolResponse: Codable {
    let success: Bool
    let symbols: [String: String]
}

struct CurrencyRatesResponse: Codable {
    let success: Bool
    let timestamp: Int
    let base: String
    let date: String
    let rates: [String: Double]
}

enum CurrencyError: Error {
    case invalidURL
    case invalidData
    case invalidResponse
}


//class CurrencyModel {
//    // MARK: - Properties
//    private let accessKey: String
//    private let baseURL: String
//    let currencyBase = "EUR"
//    let currencyCode = "USD"
//    
//    var exchangeRate: Double = 0
//    var rates = [String: Double]()
//    var timestamp: Int = 0
//    var symbols = [String: String]()
//    
//    // MARK: - Initializer
//    init() {
//        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
//              let keys = NSDictionary(contentsOfFile: path),
//              let accessKey = keys["FixerApiKey"] as? String,
//              let baseURL = keys["FixerApiURL"] as? String else {
//            fatalError("Unable to read keys from Keys.plist")
//        }
//        self.accessKey = accessKey
//        self.baseURL = baseURL
//    }
//    
//    // MARK: - Methods
//    func getCurrencyCodes(completion: @escaping ([String : String]) -> Void) {
//        if self.symbols.isEmpty {
//            let currencyService = CurrencyService(accessKey: accessKey, baseURL: baseURL)
//            currencyService.getCurrencyCodes { symbols in
//                self.symbols = symbols
//                completion(symbols)
//            }
//        } else {
//            completion(self.symbols)
//        }
//    }
//    
//    func convert(amount: Double, country: String, completion: @escaping (Double?) -> Void) {
//        if self.timestamp != 0 && Date().timeIntervalSince1970 - Double(self.timestamp) < 86400 {
//            let exchangeRate = self.rates[country] ?? 0
//            let result = amount * exchangeRate
//            completion(Double(round(100 * result) / 100))
//        } else {
//            let currencyService = CurrencyService(accessKey: accessKey, baseURL: baseURL)
//            currencyService.convert(amount: amount, from: currencyBase, to: currencyCode) { result in
//                self.timestamp = currencyService.timestamp
//                self.exchangeRate = currencyService.exchangeRate
//                completion(result)
//            }
//        }
//    }
//    
//    func getRatesWithAPI(completion: @escaping ([String: Double]?) -> Void) {
//        if self.rates.isEmpty {
//            let currencyService = CurrencyService(accessKey: accessKey, baseURL: baseURL)
//            currencyService.getRates(currencyBase: currencyBase, symbols: symbols) { rates in
//                self.rates = rates
//                self.timestamp = currencyService.timestamp
//                completion(rates)
//            }
//        } else {
//            completion(self.rates)
//        }
//    }
//}
