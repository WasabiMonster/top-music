//
//  ApiError.swift
//  Top Music
//
//  Created by Patrick Wilson on 8/26/20.
//  Copyright © 2020 Etechitronica LLC. All rights reserved.
//

import Foundation

enum ApiError: Error {
    case noInternetConnection
    case requestEncodingFailed  // Request parameters and/or body encoding failed
    case responseDecodingFailed // Response object could not be decoded"
    case badUrl // Could not generate a valid url
    case unexpectedResultCode(statusCode: Int)  // server returned unexpected result code
    case serverError // Server returned an generic error
    case serverReturnedErrorMessage(message: String) // server returned a specific error message
    case serverOverload // 503 response
    case timeout // 408 response

    public var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "no internet connection"

        case .requestEncodingFailed:
            return "failed to encode request"

        case .responseDecodingFailed:
            return "failed to decode server response"

        case .badUrl:
            return "invalid url"

        case .unexpectedResultCode(let statusCode):
            return "unexpected result code from server \(statusCode)"

        case .serverError:
            return "server error"

        case .serverReturnedErrorMessage(let message):
            return "server generated error message: \(message)"

        case .serverOverload:
            return "server overload"

        case .timeout:
            return "timeout"
        }
    }
}

extension ApiError {

    func getUserMessage() -> String {
        switch self {
        case .noInternetConnection:
            return NSLocalizedString("Sorry, we are unable to connect to the server. Please check your network and try again.",
                                     comment: "No network connection")
        case .requestEncodingFailed, .responseDecodingFailed, .badUrl, .serverError:
            return NSLocalizedString("We are sorry, our service is currently experiencing issues. Please try again later.",
                comment: "Generic error message")
        case .unexpectedResultCode(let statusCode) where statusCode == 500:
            return NSLocalizedString("Sorry, we are unable to reach our server. Please try again later.",
                                     comment: "Server 500 error")
        case .unexpectedResultCode(let statusCode):
            return NSLocalizedString("We are sorry, our service is currently experiencing issues. Please try again later! (Error Code: \(statusCode))",
                comment: "Error messaging")
        case .serverReturnedErrorMessage(let message):
            return message
        case .serverOverload:
            return NSLocalizedString("Sorry, our servers are currently experiencing high volume. Please come back later.",
                              comment: "Server overload error")
        case .timeout:
            return NSLocalizedString("Sorry, your request has timed out. Please try again later.",
                                     comment: "Time out error")
        }
    }

    func getHttpStatusCode() -> Int {
        switch self {
        case .noInternetConnection:
            return 0
        case .requestEncodingFailed, .responseDecodingFailed, .badUrl:
            return 0
        case .unexpectedResultCode(let statusCode):
            return statusCode
        case .serverReturnedErrorMessage:
            return 0
        case .serverOverload:
            return 503
        case .timeout:
            return 408
        case .serverError:
            return 0
        }
    }

}

extension ApiError: Equatable {
    static func == (lhs: ApiError, rhs: ApiError) -> Bool {
        switch (lhs, rhs) {
        case (let .serverReturnedErrorMessage(lhsMessage), let .serverReturnedErrorMessage(rhsMessage)):
            return lhsMessage == rhsMessage
        case (let .unexpectedResultCode(lhsStatusCode), let .unexpectedResultCode(rhsStatusCode)):
            return lhsStatusCode == rhsStatusCode
        case (.noInternetConnection, .noInternetConnection),
             (.requestEncodingFailed, requestEncodingFailed),
             (.responseDecodingFailed, .responseDecodingFailed),
             (.badUrl, .badUrl),
             (.serverError, .serverError),
             (.serverOverload, .serverOverload),
             (.timeout, .timeout):
            return true
        default:
            return false
        }
    }
}
