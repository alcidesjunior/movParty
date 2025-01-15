import Foundation

final class Service: ServiceProtocol {
    private let session: URLSession
    private let jsonDecoder: JSONDecoder
    
    private let requestBuilder: RequestBuilderProtocol
    
    init(session: URLSession, jsonDecoder: JSONDecoder, requestBuilder: RequestBuilderProtocol) {
        self.session = session
        self.jsonDecoder = jsonDecoder
        self.requestBuilder = requestBuilder
    }
    
    func execute<T: Codable>(request: RequestProtocol, completion: @escaping (Result<T, Error>) -> Void) {
        requestBuilder.setMethod(request.method)
        
        if let body = request.body {
            do {
                try requestBuilder.setBody(body: body, requestEncoding: request.encoding, method: request.method)
            } catch let error {
                completion(.failure(MPError.failedToEncode(error)))
            }
        }
        
        if let headers = request.headers {
            requestBuilder.addHeaders(headers)
        }
        
        let urlRequest = requestBuilder.build()

        let task = session.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self = self else {
                return completion(.failure(MPError.sessionDeallocated))
            }
            
            guard let jsonData = data else {
                return completion(.failure(MPError.noData))
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                return completion(.failure(MPError.invalidResponse))
            }
            
            do {
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let decodedData = try jsonDecoder.decode(T.self, from: jsonData)
                completion(.success(decodedData))
            } catch let error {
                completion(.failure(MPError.failedToDecode(error)))
            }
        }
        task.resume()
    }
}
