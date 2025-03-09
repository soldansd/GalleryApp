//
//  NetworkError.swift
//  Gallery
//
//  Created by Даниил Соловьев on 09/03/2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case badResponse
    case invalidStatusCode(Int)
    case noData
    case decodingFailed
}
