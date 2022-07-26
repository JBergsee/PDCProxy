//
//  File.swift
//  
//
//  Created by Johan Nyman on 2022-07-25.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let setLogData = try? newJSONDecoder().decode(SetLogData.self, from: jsonData)

// MARK: - SetLogData
struct SetPilotsLogResult: Codable {
    let id: Int
    let jsonrpc, result: String
}
