import Foundation

protocol ServiceProtocol {
    func execute<T: Codable>(request: RequestProtocol, completion: @escaping (Result<T, Error>) -> Void)
}
