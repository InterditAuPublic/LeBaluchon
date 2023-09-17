//
//  Translation.swift
//  Le Baluchon
//
//  Created by Melvin Poutrel on 11/05/2023.
//
import Foundation

// MARK: - Translation
struct Translation: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let translations: [TranslationElement]
}

// MARK: - TranslationElement
struct TranslationElement: Codable {
    let translatedText: String
}

// MARK: - TranslationRequest
struct TranslationRequest: Codable {
    let source: String
    let target: String
    let text: String
}

// MARK: - TranslationResponse
struct TranslationResponse: Codable {
    let translatedText: String
}

// // MARK: - TranslationError
// struct TranslationError: Codable, Error {
//     let code: Int
//     let message: String
    
//     enum CodingKeys: String, CodingKey {
//         case code = "code"
//         case message = "message"
//     }

//     init(code: Int, message: String) {
//         self.code = code
//         self.message = message
//     }
// }

// MARK: - TranslationError
enum TranslationError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError(String)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response"
        case .noData:
            return "No data received"
        case .decodingError(let message):
            return "\(message)"
        }
    }
}
