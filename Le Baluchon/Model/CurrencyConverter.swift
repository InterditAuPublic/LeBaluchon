//
//  CurrencyConverter.swift
//  Le Baluchon
//
//  Created by Melvin Poutrel on 04/05/2023.
//

import Foundation

class CurrencyConverter {
    let accessKey = Bundle.main.object(forInfoDictionaryKey: "FixerApiKey") as? String ?? ""
    let baseURL = Bundle.main.object(forInfoDictionaryKey: "FixerApiURL") as? String ?? ""

    
    func convertToDollars(amount: Double, currencyCode: String, completion: @escaping (Double?) -> Void) {
        let url = "\(baseURL)?access_key=\(accessKey)&symbols=USD,\(currencyCode)&format=1"
        
        guard let apiUrl = URL(string: url) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: apiUrl) { data, response, error in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                  let rates = json["rates"] as? [String: Double],
                  let exchangeRate = rates[currencyCode],
                  let usdRate = rates["USD"] else {
                completion(nil)
                return
            }
            
            let usdAmount = amount * exchangeRate / usdRate
            completion(usdAmount)
        }.resume()
    }
}
