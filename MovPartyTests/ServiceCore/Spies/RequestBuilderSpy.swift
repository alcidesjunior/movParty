import Foundation

@testable import MovParty

final class RequestBuilderSpy: RequestBuilderProtocol {
    private(set) var setMethodCalled = false
    private(set) var setMethodPassed: RequestMethod?
    
    func setMethod(_ method: RequestMethod) {
        setMethodCalled = true
        setMethodPassed = method
    }
    
    private(set) var addHeadersCalled = false
    private(set) var addHeadersPassed: [String: String]?
    
    func addHeaders(_ headers: [String : String]) {
        addHeadersCalled = true
        addHeadersPassed = headers
    }
    
    private(set) var setBodyCalled = false
    private(set) var setBodyPassed: Encodable?
    private(set) var setBodyRequestEncodingPassed: RequestEncoding?
    private(set) var setBodyMethodPassed: RequestMethod?
    
    func setBody<T>(body: T?, requestEncoding: RequestEncoding, method: RequestMethod) throws where T : Encodable {
        setBodyCalled = true
        setBodyPassed = body
        setBodyRequestEncodingPassed = requestEncoding
        setBodyMethodPassed = method
    }
    
    private(set) var buildCalled = false
    var buildToBeReturned: URLRequest = URLRequest(url: URL(string: "http://example.com")!)
    
    func build() -> URLRequest {
        buildCalled = true
        
        return buildToBeReturned
    }
}
