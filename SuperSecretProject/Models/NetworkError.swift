//
//  NetworkError.swift
//  SuperSecretProject
//
//  Created by Dennis Vermeulen on 28/04/2024.
//

import Foundation

public enum NetworkError: String, Error {
    case invalidURL = "The URL you used seems to be invalid."
    case decodingFailed = "There seems to be something wrong with the data from the server."
    case noSuccess = "Whoopy daisy, there is something wrong."
}
