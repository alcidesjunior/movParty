import Foundation

final class JSONDecoderSpy: JSONDecoder {
    private(set) var decodeCalled = false
    private(set) var decodeTypePassed: Any.Type?
    private(set) var decodeDataPassed: Data?
    
    override func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
        decodeCalled = true
        decodeTypePassed = type
        decodeDataPassed = data
        return try super.decode(type, from: data)
    }
}
