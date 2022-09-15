//
//  APIError.swift
//  NiCarNaeCar
//
//  Created by 소연 on 2022/09/16.
//

import Foundation

enum APIError: Error {
    case invalidResponse
    case noData
    case failedRequest
    case invalidData
}
