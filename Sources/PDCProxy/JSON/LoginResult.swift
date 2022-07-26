//
//  LoginResult.swift
//  PDC-sender
//
//  Created by Johan Nyman on 2022-07-21.
//

import Foundation
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let loginResult = try? newJSONDecoder().decode(LoginResult.self, from: jsonData)

import Foundation

// MARK: - LoginResult
struct LoginResult: Codable {
    let id: Int
    let jsonrpc: String
    let result: Login
}

// MARK: - Result
struct Login: Codable {
    let authentication: String
    let limit: Double
}
