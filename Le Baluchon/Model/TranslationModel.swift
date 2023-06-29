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

// MARK: - TranslationError
struct TranslationError: Codable {
    let error: ErrorDetail
}

// MARK: - Error
struct ErrorDetail: Codable {
    let code: Int
    let message: String
}

// MARK: - TranslationRequest
struct TranslationRequest {
    let source: String
    let target: String
    let text: String
}

// MARK: - TranslationResponse
struct TranslationResponse {
    let translatedText: String
}
