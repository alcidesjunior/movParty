import Foundation

@testable import MovParty

final class RequestProtocolStub: RequestProtocol {
    var path: String = "http://example.com"
    var method: RequestMethod = .get
    var encoding: RequestEncoding = .json
    var body: Encodable?
    var headers: [String : String]?
}
