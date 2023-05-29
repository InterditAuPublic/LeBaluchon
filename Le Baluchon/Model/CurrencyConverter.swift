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
    private let accessKey: String
    private let baseURL: String
    let currencyBase = "EUR"
    let currencyCode = "USD"
    var exchangeRate: Double = 0 // default : 0.0
    // var rates = [String: Double]()
    var rates = ["GEL": 2.768014,
                 "UZS": 12272.569093,
                 "SOS": 610.945696,
                 "KRW": 1426.053353,
                 "GYD": 226.824253,
                 "TJS": 11.711078,
                 "LVL": 0.648912,
                 "ZMW": 20.755327,
                 "CVE": 110.922856,
                 "VND": 25183.440123,
                 "DZD": 146.717241,
                 "HKD": 8.40451,
                 "PKR": 306.813792,
                 "KYD": 0.893752,
                 "AMD": 414.527294,
                 "LRD": 180.012707,
                 "SBD": 8.933257,
                 "CHF": 0.971396,
                 "EUR": 1.0,
                 "EGP": 33.148276,
                 "HNL": 26.465127,
                 "CUC": 1.072777,
                 "PYG": 7763.244708,
                 "UGX": 4000.566841,
                 "OMR": 0.413062,
                 "KGS": 93.964399,
                 "XCD": 2.899233,
                 "ZWL": 345.433757,
                 "MDL": 19.089883,
                 "BIF": 3025.231146,
                 "SRD": 40.013259,
                 "SYP": 2695.294301,
                 "TRY": 21.402006,
                 "KZT": 478.366698,
                 "JPY": 150.261726,
                 "AOA": 585.206895,
                 "WST": 2.913234,
                 "BTN": 88.714924,
                 "SLE": 24.20654,
                 "BGN": 1.955804,
                 "BZD": 2.161706,
                 "AED": 3.939454,
                 "PGK": 3.775637,
                 "SAR": 4.022001,
                 "MGA": 4730.946811,
                 "USD": 1.072777,
                 "MAD": 10.971828,
                 "SZL": 20.650387,
                 "MMK": 2252.182094,
                 "SGD": 1.452642,
                 "CRC": 575.792319,
                 "AWG": 1.930999,
                 "MRO": 382.981205,
                 "IDR": 16066.98116,
                 "CUP": 28.428591,
                 "SHP": 1.305301,
                 "CDF": 2494.206468,
                 "XAU": 0.000553,
                 "NIO": 39.161683,
                 "KHR": 4409.114097,
                 "HTG": 151.751502,
                 "INR": 88.763232,
                 "PEN": 3.963374,
                 "IRR": 45378.467448,
                 "KMF": 491.278271,
                 "GTQ": 8.370342,
                 "BYR": 21026.42924,
                 "XDR": 0.804014,
                 "LSL": 20.651111,
                 "LKR": 324.305951,
                 "ERN": 16.091655,
                 "LBP": 16204.296568,
                 "AZN": 1.821979,
                 "XAG": 0.047188,
                 "MKD": 61.610808,
                 "DJF": 190.653554,
                 "LAK": 18921.10147,
                 "TOP": 2.548056,
                 "ALL": 110.318348,
                 "NOK": 11.85594,
                 "ETB": 58.260773,
                 "PAB": 1.072452,
                 "TND": 3.315686,
                 "HUF": 373.106512,
                 "TMT": 3.75472,
                 "DOP": 58.519567,
                 "STD": 22204.318014,
                 "ZMK": 9656.277947,
                 "MYR": 4.962131,
                 "RWF": 1214.919955,
                 "MNT": 3743.706946,
                 "HRK": 7.449729,
                 "CZK": 23.620083,
                 "VES": 27.896549,
                 "GHS": 11.800399,
                 "IMP": 0.867411,
                 "ILS": 4.000708,
                 "ZAR": 21.259542,
                 "BRL": 5.403257,
                 "SCR": 15.093802,
                 "BOB": 7.411259,
                 "JEP": 0.867411,
                 "MZN": 67.852927,
                 "XPF": 119.480529,
                 "UAH": 39.61032,
                 "XAF": 656.062189,
                 "UYU": 41.447032,
                 "BTC": 4.0520397e-05,
                 "GBP": 0.87051,
                 "NAD": 20.651071,
                 "ANG": 1.93281,
                 "JOD": 0.761133,
                 "CNY": 7.594078,
                 "BBD": 2.165307,
                 "RUB": 85.84902,
                 "RON": 4.952152,
                 "AUD": 1.648671,
                 "DKK": 7.449696,
                 "ISK": 150.102868,
                 "CLF": 0.031437,
                 "BWP": 14.631482,
                 "SLL": 21187.345593,
                 "CAD": 1.463187,
                 "PHP": 60.217181,
                 "LTL": 3.167631,
                 "AFN": 93.879117,
                 "VEF": 2785677.286174,
                 "FKP": 0.867411,
                 "MXN": 19.153382,
                 "YER": 268.569772,
                 "MUR": 48.812594,
                 "KPW": 965.432388,
                 "GMD": 63.88358,
                 "FJD": 2.412944,
                 "SVC": 9.38333,
                 "KWD": 0.329954,
                 "THB": 37.250577,
                 "MWK": 1097.990635,
                 "RSD": 117.249175,
                 "IQD": 1405.337873,
                 "BDT": 114.978435,
                 "GIP": 0.867411,
                 "COP": 4818.914293,
                 "BAM": 1.956114,
                 "MOP": 8.651907,
                 "MVR": 16.477689,
                 "BSD": 1.072452,
                 "JMD": 165.336509,
                 "NPR": 141.943758,
                 "LYD": 5.165432,
                 "TZS": 2537.117847,
                 "GNF": 9284.884809,
                 "BMD": 1.072777,
                 "BND": 1.451206,
                 "BYN": 2.706884,
                 "KES": 148.311172,
                 "XOF": 652.784146,
                 "TTD": 7.293169,
                 "SDG": 644.200016,
                 "BHD": 0.404421,
                 "GGP": 0.867411,
                 "SEK": 11.59849,
                 "NGN": 495.02852,
                 "QAR": 3.905953,
                 "TWD": 33.026301,
                 "CLP": 867.451009,
                 "VUV": 128.182226,
                 "NZD": 1.769218,
                 "ARS": 252.88808,
                 "PLN": 4.503088]
    
    var timestamp: Int = 1685054137 // default : 0
    
    //    var symbols = [String: String]()
    
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
                print(String(describing: error))
                return
            }
            
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            let symbols = json["symbols"] as! [String: String]
            self.symbols = symbols
        }
        task.resume()
    }
    
    func convert(amount: Double, country: String, completion: @escaping (Double?) -> Void) {
        if (self.timestamp != 0 && Date().timeIntervalSince1970 - Double(self.timestamp) < 86400) {
            print("WITHOUT API")
    let exchangeRate = self.rates[country] ?? 0
            print(exchangeRate)
            var result = amount * exchangeRate
            result = Double(round(100*result)/100)
            completion(result)
        } else {
            print("WITH API")
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
    
    func getRatesWithAPI(completion: @escaping ([String: Double]?) -> Void) {
        if self.rates.isEmpty {
            print("getRatesWithAPI")
            
            var currencyCode = [String].self()
            for (key, _) in symbols {
                currencyCode.append(key)
            }
            let currencyCodes = currencyCode.joined(separator: ",")
            
            let url = "\(baseURL)latest?symbols=\(currencyCodes)&base=\(currencyBase)"
            print(url)
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
                    print("Error parsing JSON or extracting rates value")
                    completion(nil)
                    return
                }
                
                self.rates = rates

                for (key, value) in self.rates {
                    print("RATES : \(key) : \(value)")
                }
                self.timestamp = timestamp
                
                completion(rates)
            }
            task.resume()
        }
    }
}
