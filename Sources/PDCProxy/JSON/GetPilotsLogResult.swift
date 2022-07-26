//
//  GetPilotsLogResult.swift
//  PDC-sender
//
//  Created by Johan Nyman on 2022-07-21.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let getPilotsLogResult = try? newJSONDecoder().decode(GetPilotsLogResult.self, from: jsonData)

import Foundation

// MARK: - GetPilotsLogResult
struct GetPilotsLogResult: Codable {
    let id: Int
    let jsonrpc: String
    let result: PDCCrewList
}
