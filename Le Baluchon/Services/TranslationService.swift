//
//  TranslateService.swift
//  Le Baluchon
//
//  Created by Melvin Poutrel on 09/06/2023.
//

import Foundation

// MARK: - TranslationService
protocol TranslationService {
    func getTranslation(request: TranslationRequest, callback: @escaping (Bool, TranslationResponse?) -> Void)
}

class TranslationServiceImplementation: TranslationService {
    var task: URLSessionDataTask?
    let session: any URLSessionProtocol
    private let accessKey: String
    private let baseURL: String

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
        guard let url = URL(string: "\(baseURL)?key=\(accessKey)&source=\(request.source)&target=\(request.target)&q=\(request.text)") else {
            callback(false, nil)
            return
        }
        task?.cancel()
        let urlRequest = URLRequest(url: url)
        task = session.dataTask(with: urlRequest) { (data, response, error) in
            DispatchQueue.main.async {
                print("get translation")
                guard let data = data, error == nil else {
                    print("pas data")
                    callback(false, nil)
                    return
                }
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    print("pas reponse ou pas 200")
                    callback(false, nil)
                    return
                }
                guard let responseJSON = try? JSONDecoder().decode(Translation.self, from: data) else {
                    print("pas JSON")
                    callback(false, nil)
                    return
                }
                guard let text = responseJSON.data.translations[0].translatedText.removingPercentEncoding else {
                    print("pas translated")
                    callback(false, nil)
                    return
                }
                let translationResponse = TranslationResponse(translatedText: text)
                callback(true, translationResponse)
            }
        } as? URLSessionDataTask
        task?.resume()
    }
}
