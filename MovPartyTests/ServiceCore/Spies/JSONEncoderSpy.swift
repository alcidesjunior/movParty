import Foundation

final class JSONEncoderSpy: JSONEncoder {
    private(set) var encodeCalled = false
    private(set) var encodeValuePassed: Any?
    
    override func encode<T>(_ value: T) throws -> Data where T : Encodable {
        encodeCalled = true
        encodeValuePassed = value
        return try super.encode(value)
    }
}
