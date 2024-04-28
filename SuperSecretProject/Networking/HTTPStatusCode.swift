//
//  HTTPStatusCode.swift
//  SuperSecretProject
//
//  Created by Dennis Vermeulen on 27/04/2024.
//

import Foundation

public enum HTTPStatusCode: Int, Error {
    case informal = 100
    case success = 200
    case redirect = 300
    case clientError = 400
    case serverError = 500
    case unknown = 999
    
    init(code: Int) {
          switch code {
              case 100...199: self = .informal
              case 200...299: self = .success
              case 300...399: self = .redirect
              case 400...499: self = .clientError
              case 500...599: self = .serverError
              default: self = .unknown
          }
      }
    
    init(urlResponse: HTTPURLResponse) {
        self.init(code: urlResponse.statusCode)
      }
}
