import XCTest

@testable import MovParty

final class ServiceTests: XCTestCase {
    private let jsonDecoderSpy = JSONDecoderSpy()
    private let requestBuilderSpy = RequestBuilderSpy()
    private let urlSessionSpy = URLSessionSpy()
    private let requestStub = RequestProtocolStub()
    
    private lazy var sut = Service(
        session: urlSessionSpy,
        jsonDecoder: jsonDecoderSpy,
        requestBuilder: requestBuilderSpy
    )
    
    func test_execute_whenReturnAValidStatusCode_shouldSucceed() {
        let expectedResponse: DataModelDummy = .fixture()
        let data = try? JSONEncoder().encode(expectedResponse)
        urlSessionSpy.dataToReturn = data
        guard let url = URL(string: "https://example.com") else {
           return XCTFail()
        }
        let statusCode = Int.random(in: 200...299)
        urlSessionSpy.responseToReturn = HTTPURLResponse(
            url: url,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )
        
        let expectation = self.expectation(description: "Completion handler called")
        
        sut.execute(request: requestStub) {
            (result: Result<DataModelDummy, Error>) in
            switch result {
            case .success(let response): 
                XCTAssertEqual(response.name, "name")
                break
            default:
                XCTFail()
            }
        }
        
        wait(for: [expectation], timeout: 1)
    }
}
