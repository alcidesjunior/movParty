import Foundation

protocol RequestProtocol {
    var path: String { get }
    var method: RequestMethod { get }
    var encoding: RequestEncoding { get }
    var body: Encodable? { get }
    var headers: [String: String]? { get }
}
