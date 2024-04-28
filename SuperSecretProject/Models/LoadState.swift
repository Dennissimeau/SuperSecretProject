//
//  LoadState.swift
//  SuperSecretProject
//
//  Created by Dennis Vermeulen on 28/04/2024.
//

import Foundation

public enum LoadState {
    case start
    case error(errorMessage: Error)
    case loading
    case retrieved
}

extension LoadState: Equatable {
    public static func ==(lhs: LoadState, rhs: LoadState) -> Bool {
        switch (lhs, rhs) {
        case (.start, .start), (.loading, .loading), (.retrieved, .retrieved):
            return true
        case let (.error(lhsError), .error(rhsError)):
            // Compare errors by some criteria, e.g., their localized descriptions if they are CustomStringConvertible
            return (lhsError as CustomStringConvertible).description == (rhsError as CustomStringConvertible).description
        default:
            return false
        }
    }
}
