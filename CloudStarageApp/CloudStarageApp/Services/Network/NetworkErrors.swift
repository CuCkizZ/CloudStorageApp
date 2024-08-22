//
//  NetworkErrors.swift
//  CloudStarageApp
//
//  Created by Nikita Beglov on 09.08.2024.
//

import Foundation

enum NetworkErrors: Error {
    case serverError
    case responseError
    case internetError
}

protocol LocalizedError: Error {
    var errorDescription: String? { get }
    var failureReason: String? { get }
    var recoverySuggestion: String? { get }
    var helpAnchor: String? { get }
}



extension NetworkErrors: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .serverError, .responseError:
            return "Error"
        case .internetError:
            return "No Internet Connection"
        }
    }
    
    var failureReason: String? {
        switch self {
        case .serverError, .responseError:
            return "Something went wrong"
        case .internetError:
            return nil
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .serverError, .responseError:
            return "Please, try again"
        case .internetError:
            return "Please check your internet connection and try again"
        }
    }
    
    var helpAnchor: String? {
        return "help"
    }
}
