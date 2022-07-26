//
//  MethodsRequest.swift
//  PDC-sender
//
//  Created by Johan Nyman on 2022-07-21.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let methodsRequest = try? newJSONDecoder().decode(MethodsRequest.self, from: jsonData)

import Foundation

// MARK: - MethodsRequest
class VersionRequest: Codable {
    private var jsonrpc: String = "2.0"
    private var id: Int = 1
    private var method: String = "version"
    private var params: VersionParams = VersionParams(methods: [])

    init() {
    
    }
}

// MARK: - Params
struct VersionParams: Codable {
    let methods: [JSONAny]
}
