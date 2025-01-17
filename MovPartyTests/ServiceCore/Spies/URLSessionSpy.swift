import Foundation

final class URLSessionSpy: URLSession {
    private(set) var dataTaskCalled = false
    private(set) var requestPassed: URLRequest?
    private(set) var completionHandlerPassed: ((Data?, URLResponse?, Error?) -> Void)?
    
    var dataToReturn: Data?
    var errorToReturn: Error?
    var responseToReturn: URLResponse?

    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        dataTaskCalled = true
        requestPassed = request
        completionHandlerPassed = completionHandler
        
        return URLSessionDataTaskSpy {
            completionHandler(self.dataToReturn, self.responseToReturn, self.errorToReturn)
        }
    }
}

final class URLSessionDataTaskSpy: URLSessionDataTask {
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    override func resume() {
        closure()
    }
}
