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

struct CurrencyConversionResponse: Codable {
    let date: String
    let historical: String?
    let info: ConversionInfo
    let query: ConversionQuery
    let result: Double
    let success: Bool
}

struct ConversionInfo: Codable {
    let rate: Double
    let timestamp: Int
}

struct ConversionQuery: Codable {
    let amount: Double
    let from: String
    let to: String
}

enum CurrencyError: Error {
    case invalidURL
    case invalidData
    case invalidResponse
}
