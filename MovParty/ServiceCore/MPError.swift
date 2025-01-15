import Foundation

enum MPError: Error {
    case noData
    case invalidRequest
    case invalidResponse
    case sessionDeallocated
    case failedToDecode(Error)
    case failedToEncode(Error)
    case invalidURL
}
