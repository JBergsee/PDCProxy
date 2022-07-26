//
//  MethodsResult.swift
//  PDC-sender
//
//  Created by Johan Nyman on 2022-07-21.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let methodsResult = try? newJSONDecoder().decode(MethodsResult.self, from: jsonData)

import Foundation

// MARK: - MethodsResult
struct VersionResult: Codable {
    let id: Int
    let jsonrpc: String
    let result: PDCVersion
}

// MARK: - Result
public struct PDCVersion: Codable {
    public let build: String
    public let methods: [String: Method]
    public let program, version: String
}

// MARK: - Method
public struct Method: Codable {
}
