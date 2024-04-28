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
