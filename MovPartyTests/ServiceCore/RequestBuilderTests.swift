import XCTest

@testable import MovParty

final class RequestBuilderTests: XCTestCase {
    private let urlRequestSpy = URLRequest(url: URL)
    private lazy var sut = RequestBuilder(
        urlRequest: <#T##URLRequest#>,
        encoder: <#T##JSONEncoder#>
    )

}
