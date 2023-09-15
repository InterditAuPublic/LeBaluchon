//
//  TranslateService.swift
//  Le Baluchon
//
//  Created by Melvin Poutrel on 09/06/2023.
//

import Foundation

// MARK: - TranslationService
protocol TranslationService {
func getTranslation(request: TranslationRequest, completion: @escaping (Result<TranslationResponse, Error>) -> Void)
}


class TranslationServiceImplementation: TranslationService {

var task: URLSessionDataTask?
let urlSession: any URLSessionProtocol
private let accessKey: String
private let baseURL: String

init(urlSession: any URLSessionProtocol = URLSession(configuration: .default)) {
    self.urlSession = urlSession
    guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
          let keys = NSDictionary(contentsOfFile: path),
          let accessKey = keys["CloudTranslationApiKey"] as? String,
          let baseURL = keys["CloudTranslationBaseURL"] as? String else {
        fatalError("Unable to read keys from Keys.plist")
    }
    self.accessKey = accessKey
    self.baseURL = baseURL
}

func getTranslation(request: TranslationRequest, completion: @escaping (Result<TranslationResponse, Error>) -> Void) {
guard let url = URL(string: "\(baseURL)?key=\(accessKey)&source=\(request.source)&target=\(request.target)&q=\(request.text)") else {
    completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
    return
}

task?.cancel()
let urlRequest = URLRequest(url: url)

task = urlSession.dataTask(with: urlRequest) { (data, response, error) in
    DispatchQueue.main.async {
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            completion(.failure(NSError(domain: "Invalid response", code: 200, userInfo: nil)))
            return
        }

        guard let data = data else {
            completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
            return
        }

        do {
            let responseJSON = try JSONDecoder().decode(Translation.self, from: data)
            guard let text = responseJSON.data.translations.first?.translatedText.removingPercentEncoding else {
                completion(.failure(NSError(domain: "Invalid translation data", code: -1, userInfo: nil)))
                return
            }
            let translationResponse = TranslationResponse(translatedText: text)
            completion(.success(translationResponse))
        } catch {
            completion(.failure(error))
        }
    }
} as? URLSessionDataTask
task?.resume()
}
    

}
