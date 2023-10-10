import Foundation

// MARK: - TranslationServiceProtocol
protocol TranslationServiceProtocol {
    func getTranslation(request: TranslationRequest, completion: @escaping (Result<TranslationResponse, TranslationError>) -> Void)
}

class TranslationServiceImplementation: TranslationServiceProtocol {

    // MARK: - Properties
    private let accessKey: String
    private let baseURL: String
    private let urlSession: any URLSessionProtocol

    init(urlSession: any URLSessionProtocol =  URLSession(configuration: .default)) {
        self.urlSession = urlSession
        let path = Bundle.main.path(forResource: "Keys", ofType: "plist")!
        let keys = NSDictionary(contentsOfFile: path)
        let accessKey = keys!["CloudTranslationApiKey"] as? String
        let baseURL = keys!["CloudTranslationBaseURL"] as? String
        self.accessKey = accessKey!
        self.baseURL = baseURL!
    }

    // MARK: - Methods

    func getTranslation(request: TranslationRequest, completion: @escaping (Result<TranslationResponse, TranslationError>) -> Void) {
        let url = URL(string:"\(baseURL)?key=\(accessKey)&source=\(request.source)&target=\(request.target)&q=\(request.text)")!
            

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"

        let task = self.urlSession.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                if error != nil {
                    completion(.failure(TranslationError.networkError))
                    return
                }

                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completion(.failure(TranslationError.invalidResponse))
                    return
                }

                guard let data = data else {
                    completion(.failure(TranslationError.noData))
                    return
                }

                do {
                    let responseJSON = try JSONDecoder().decode(Translation.self, from: data)
                    let translatedText = responseJSON.data.translations.first?.translatedText
                    let translationResponse = TranslationResponse(translatedText: translatedText!)
                    completion(.success(translationResponse))
                } catch {
                    completion(.failure(TranslationError.decodingError(error.localizedDescription)))
                }
            }
        }
        task.resume()
    }
}
