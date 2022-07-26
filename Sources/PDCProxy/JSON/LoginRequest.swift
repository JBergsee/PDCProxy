//
//  LoginRequest.swift
//  PDC-sender
//
//  Created by Johan Nyman on 2022-07-21.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let loginRequest = try? newJSONDecoder().decode(LoginRequest.self, from: jsonData)

import Foundation

// MARK: - LoginRequest
class LoginRequest: Codable {
    private var jsonrpc: String = "2.0"
    private var id: Int = 2
    private var method: String = "login"
    let params: LoginParams

    init(params: LoginParams) {
        self.params = params
    }
}

// MARK: - Params
struct LoginParams: Codable {
    let username, password: String
    let crewmemberLogin: Bool
}
