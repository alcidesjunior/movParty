import Foundation

enum MPError: Error, Equatable {
    static func == (lhs: MPError, rhs: MPError) -> Bool {
        switch (lhs, rhs) {
        case (.noData, .noData),
             (.invalidRequest, .invalidRequest),
             (.invalidResponse, .invalidResponse),
             (.sessionDeallocated, .sessionDeallocated),
             (.invalidURL, .invalidURL):
            return true
        case let (.failedToDecode(lhsError), .failedToDecode(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case let (.failedToEncode(lhsError), .failedToEncode(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
    
    case noData
    case invalidRequest
    case invalidResponse
    case sessionDeallocated
    case failedToDecode(Error)
    case failedToEncode(Error)
    case invalidURL
}
