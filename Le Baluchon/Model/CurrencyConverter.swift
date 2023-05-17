//
//  CurrencyConverter.swift
//  Le Baluchon
//
//  Created by Melvin Poutrel on 04/05/2023.
//

import Foundation

// MARK: - CurrencyConverter

class CurrencyConverter {
    
    // MARK: - Properties
    var accessKey = String()
    var baseURL = String()
    let currencyBase = "EUR"
    let currencyCode = "USD"
    var exchangeRate: Double = 0 // default : 0.0
    var timestamp: Int = 0 // default : 0
    
    // replace by API call to get all symbols and their names (e.g. USD: United States Dollar) and store them in a dictionary
    var symbols: [String: String] = ["DOP": "Dominican Peso", "INR": "Indian Rupee", "GMD": "Gambian Dalasi", "BTN": "Bhutanese Ngultrum", "SOS": "Somali Shilling", "TTD": "Trinidad and Tobago Dollar", "CRC": "Costa Rican Colón", "FJD": "Fijian Dollar", "SLE": "Sierra Leonean Leone", "GEL": "Georgian Lari", "DZD": "Algerian Dinar", "NIO": "Nicaraguan Córdoba", "VND": "Vietnamese Dong", "MKD": "Macedonian Denar", "SLL": "Sierra Leonean Leone", "JOD": "Jordanian Dinar", "BHD": "Bahraini Dinar", "PLN": "Polish Zloty", "SZL": "Swazi Lilangeni", "SCR": "Seychellois Rupee", "LYD": "Libyan Dinar", "JPY": "Japanese Yen", "BDT": "Bangladeshi Taka", "BGN": "Bulgarian Lev", "NOK": "Norwegian Krone", "CDF": "Congolese Franc", "XAF": "CFA Franc BEAC", "UYU": "Uruguayan Peso", "CUP": "Cuban Peso", "AUD": "Australian Dollar", "VES": "Sovereign Bolivar", "UZS": "Uzbekistan Som", "ZAR": "South African Rand", "PAB": "Panamanian Balboa", "TJS": "Tajikistani Somoni", "NGN": "Nigerian Naira", "VEF": "Venezuelan Bolívar Fuerte", "MRO": "Mauritanian Ouguiya", "COP": "Colombian Peso", "KES": "Kenyan Shilling", "SYP": "Syrian Pound", "MDL": "Moldovan Leu", "PEN": "Peruvian Nuevo Sol", "BYR": "Belarusian Ruble", "JMD": "Jamaican Dollar", "BZD": "Belize Dollar", "ANG": "Netherlands Antillean Guilder", "TOP": "Tongan Paʻanga", "TRY": "Turkish Lira", "MMK": "Myanma Kyat", "BBD": "Barbadian Dollar", "LTL": "Lithuanian Litas", "LAK": "Laotian Kip", "VUV": "Vanuatu Vatu", "OMR": "Omani Rial", "DKK": "Danish Krone", "BWP": "Botswanan Pula", "BIF": "Burundian Franc", "MZN": "Mozambican Metical", "IQD": "Iraqi Dinar", "GYD": "Guyanaese Dollar", "ERN": "Eritrean Nakfa", "JEP": "Jersey Pound", "CZK": "Czech Republic Koruna", "IMP": "Manx pound", "GTQ": "Guatemalan Quetzal", "SEK": "Swedish Krona", "IRR": "Iranian Rial", "BYN": "New Belarusian Ruble", "KRW": "South Korean Won", "MXN": "Mexican Peso", "CNY": "Chinese Yuan", "XCD": "East Caribbean Dollar", "AMD": "Armenian Dram", "WST": "Samoan Tala", "PKR": "Pakistani Rupee", "GBP": "British Pound Sterling", "NPR": "Nepalese Rupee", "AZN": "Azerbaijani Manat", "KHR": "Cambodian Riel", "EGP": "Egyptian Pound", "BRL": "Brazilian Real", "HUF": "Hungarian Forint", "MUR": "Mauritian Rupee", "AFN": "Afghan Afghani", "BND": "Brunei Dollar", "LKR": "Sri Lankan Rupee", "GNF": "Guinean Franc", "SGD": "Singapore Dollar", "KYD": "Cayman Islands Dollar", "BOB": "Bolivian Boliviano", "GGP": "Guernsey Pound", "XAU": "Gold (troy ounce)", "ETB": "Ethiopian Birr", "KWD": "Kuwaiti Dinar", "RWF": "Rwandan Franc", "RUB": "Russian Ruble", "MVR": "Maldivian Rufiyaa", "MWK": "Malawian Kwacha", "PHP": "Philippine Peso", "CLF": "Chilean Unit of Account (UF)", "PYG": "Paraguayan Guarani", "NZD": "New Zealand Dollar", "TND": "Tunisian Dinar", "IDR": "Indonesian Rupiah", "XDR": "Special Drawing Rights", "SAR": "Saudi Riyal", "EUR": "Euro", "CLP": "Chilean Peso", "KMF": "Comorian Franc", "KGS": "Kyrgystani Som", "DJF": "Djiboutian Franc", "GHS": "Ghanaian Cedi", "AED": "United Arab Emirates Dirham", "THB": "Thai Baht", "LBP": "Lebanese Pound", "STD": "São Tomé and Príncipe Dobra", "MOP": "Macanese Pataca", "SVC": "Salvadoran Colón", "KZT": "Kazakhstani Tenge", "TZS": "Tanzanian Shilling", "RON": "Romanian Leu", "CUC": "Cuban Convertible Peso", "SDG": "Sudanese Pound", "ARS": "Argentine Peso", "CHF": "Swiss Franc", "TMT": "Turkmenistani Manat", "HRK": "Croatian Kuna", "GIP": "Gibraltar Pound", "ALL": "Albanian Lek", "LSL": "Lesotho Loti", "MGA": "Malagasy Ariary", "RSD": "Serbian Dinar", "SBD": "Solomon Islands Dollar", "AWG": "Aruban Florin", "NAD": "Namibian Dollar", "BMD": "Bermudan Dollar", "UGX": "Ugandan Shilling", "LVL": "Latvian Lats", "XAG": "Silver (troy ounce)", "MAD": "Moroccan Dirham", "BAM": "Bosnia-Herzegovina Convertible Mark", "FKP": "Falkland Islands Pound", "ZWL": "Zimbabwean Dollar", "TWD": "New Taiwan Dollar", "AOA": "Angolan Kwanza", "KPW": "North Korean Won", "ZMK": "Zambian Kwacha (pre-2013)", "HNL": "Honduran Lempira", "CAD": "Canadian Dollar", "PGK": "Papua New Guinean Kina", "HTG": "Haitian Gourde", "LRD": "Liberian Dollar", "BTC": "Bitcoin", "XPF": "CFP Franc", "ISK": "Icelandic Króna", "MNT": "Mongolian Tugrik", "SHP": "Saint Helena Pound", "ZMW": "Zambian Kwacha", "MYR": "Malaysian Ringgit", "SRD": "Surinamese Dollar", "YER": "Yemeni Rial", "USD": "United States Dollar", "BSD": "Bahamian Dollar", "ILS": "Israeli New Sheqel", "UAH": "Ukrainian Hryvnia", "QAR": "Qatari Rial", "HKD": "Hong Kong Dollar", "XOF": "CFA Franc BCEAO", "CVE": "Cape Verdean Escudo"]
    
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
    }
    
    func getAllSymbols() {
        let url = "\(baseURL)symbols"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.addValue(accessKey, forHTTPHeaderField: "apikey")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            let symbols = json["symbols"] as! [String: String]
            self.symbols = symbols
            print(symbols)
            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    func convert(amount: Double, completion: @escaping (Double?) -> Void) {
        if (self.timestamp != 0 && Date().timeIntervalSince1970 - Double(self.timestamp) < 86400) {
            print("WITHOUT API")
            var result = amount * self.exchangeRate
            result = Double(round(100*result)/100)
            completion(result)
        } else {
            print("WITH API")
            return convertWithAPI(amount: amount, completion: completion)
        }
        print(timestamp, exchangeRate)
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
                print("No data received")
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
    
    
    func convertToDollars(amount: Double, completion: @escaping (Double?) -> Void) {
        
        guard var urlComponents = URLComponents(string: baseURL) else {
            completion(nil)
            return
        }
        urlComponents.path = "/fixer/convert"
        urlComponents.queryItems = [
            URLQueryItem(name: "to", value: "EUR"),
            URLQueryItem(name: "from", value: "USD"),
            URLQueryItem(name: "amount", value: String(amount))
        ]
        
        guard let url = urlComponents.url else {
            print("Invalid URL: \(urlComponents)")
            completion(nil)
            return
        }
        print(url)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(accessKey, forHTTPHeaderField: "apikey")
        
        print(request)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let jsonResponse = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: jsonResponse, options: []) as? [String: Any],
                  let result = json["result"] as? Double,
                  let info = json["info"] as? [String: Any],
                  let rate = info["rate"] as? Double else {
                print("Error parsing JSON or extracting rate value")
                completion(nil)
                return
            }

            completion(result)
        }
        task.resume()
    }
}
