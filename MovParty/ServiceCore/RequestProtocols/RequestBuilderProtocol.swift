import Foundation

protocol RequestBuilderProtocol {
    func setMethod(_ method: RequestMethod)
    func addHeaders(_ headers: [String: String])
    func setBody<T: Encodable>(body: T?, requestEncoding: RequestEncoding, method: RequestMethod) throws
    func build() -> URLRequest
}
