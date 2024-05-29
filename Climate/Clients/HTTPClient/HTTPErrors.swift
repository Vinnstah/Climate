import Foundation

enum HTTPStatusCodes: IntegerLiteralType, Error {
    case Ok = 200
    case BadRequest = 400
    case Unauthorized = 401
    case NotFound = 404
    case InternalServerError = 500
    case Unknown
}
