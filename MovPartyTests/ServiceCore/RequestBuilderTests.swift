import XCTest

@testable import MovParty

final class RequestBuilderTests: XCTestCase {
    private var urlString = "http://example.com"
    private lazy var url = URL(string: urlString)!
    private lazy var urlRequestStub = URLRequest(url: url)
    private let jsonEncoderSpy = JSONEncoderSpy()
    private lazy var sut = RequestBuilder(
        urlRequest: urlRequestStub,
        encoder: jsonEncoderSpy
    )

    func test_setMethod_whenCalled_shouldSetMethod() {
        sut.setMethod(.get)
        
        XCTAssertEqual(urlRequestStub.httpMethod, RequestMethod.get.rawValue)
    }
    
    func test_addHeaders_whenCalled_shouldSetValueToURLRequest() {
        sut.addHeaders(["key": "val"])
        let result = sut.build()
        
        XCTAssertEqual(result.value(forHTTPHeaderField: "key"), "val")
    }
    
    func test_setBody_whenRequestEncodingIsJson_andHasValidHttpMethods_shouldSetHttpBodyAndHttpHeaderField() throws {
        let body = ["key": "value"]
        let bodyToBeCompared = try jsonEncoderSpy.encode(body)
        let httpMethod: RequestMethod = [
            RequestMethod.post,
            RequestMethod.put,
            RequestMethod.patch
        ].randomElement() ?? .post
        try sut.setBody(body: body, requestEncoding: .json, method: httpMethod)
        let result = sut.build()
        
        XCTAssertTrue(jsonEncoderSpy.encodeCalled)
        XCTAssertEqual(result.httpBody, bodyToBeCompared)
        XCTAssertEqual(result.value(forHTTPHeaderField: "Content-type"), "application/json")
    }
    
    func test_setBody_whenRequestEncodingIsJson_anndMethodIsGetOrDelete_shouldNotExecute() throws {
        let body = ["key": "value"]
        let httpMethod: RequestMethod = [RequestMethod.delete, RequestMethod.get].randomElement() ?? .delete
        try sut.setBody(body: body, requestEncoding: .json, method: httpMethod)
        let result = sut.build()
        
        XCTAssertFalse(jsonEncoderSpy.encodeCalled)
        XCTAssertNil(result.httpBody)
        XCTAssertNil(result.value(forHTTPHeaderField: "Content-type"))
    }
    
    func test_setBody_whenRequestEncodingIsQuery_andHasValidHttpMethods_shouldCorrectRequestURL() throws {
        let body = ["key": "value"]
        let httpMethod: RequestMethod = [RequestMethod.delete, RequestMethod.get].randomElement() ?? .delete
        try sut.setBody(body: body, requestEncoding: .query, method: httpMethod)
        let result = sut.build()
        
        XCTAssertEqual(result.url?.absoluteString, "http://example.com?key=value")
    }
    
    func test_setBody_whenRequestEncodingIsQuery_andHasInvalidHttpMethods_shouldNotPassBody() throws {
        let body = ["key": "value"]
        let httpMethod: RequestMethod = [
            RequestMethod.post,
            RequestMethod.put,
            RequestMethod.patch
        ].randomElement() ?? .post
        try sut.setBody(body: body, requestEncoding: .query, method: httpMethod)
        let result = sut.build()
        
        XCTAssertEqual(result.url?.absoluteString, urlString)
    }
}
