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
    let error: Error
}

// MARK: - Error
struct Error: Codable {
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

// MARK: - TranslationService

protocol TranslationService {
    func getTranslation(request: TranslationRequest, callback: @escaping (Bool, TranslationResponse?) -> Void)
}

class TranslationServiceImplementation: TranslationService {

    var task: URLSessionDataTask?
    var session = URLSession(configuration: .default)
    var translation: Translation?
    var accessKey = String()
    var baseURL = String()

    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
              let keys = NSDictionary(contentsOfFile: path),
              let accessKey = keys["CloudTranslationApiKey"] as? String,
              let baseURL = keys["CloudTranslationBaseURL"] as? String else {
            fatalError("Unable to read keys from Keys.plist")
        }
        self.accessKey = accessKey
        self.baseURL = baseURL
    }

    func getTranslation(request: TranslationRequest, callback: @escaping (Bool, TranslationResponse?) -> Void) {
//       print("getTranslation")
        print("\(baseURL)?key=\(accessKey)&source=\(request.source)&target=\(request.target)&q=\(request.text)")
        guard let url = URL(string: "\(baseURL)?key=\(accessKey)&source=\(request.source)&target=\(request.target)&q=\(request.text)") else {
            callback(false, nil)
            return
        }
       task?.cancel()
        task = session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                print("data: \(String(describing: data))")
                print("response: \(String(describing: response))")
                print("error: \(String(describing: error))")

                guard let data = data, error == nil else {
                    callback(false, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    callback(false, nil)
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(Translation.self, from: data) else {
                    callback(false, nil)
                    return
                }
                let translationResponse = TranslationResponse(translatedText: responseJSON.data.translations[0].translatedText)
                callback(true, translationResponse)
                print(translationResponse)
            }
        }
        task?.resume()
    }
}
