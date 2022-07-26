//
//  GetFlightLegKeysByCrewAndDateResult.swift
//  PDC-sender
//
//  Created by Johan Nyman on 2022-07-23.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let getFlightLegKeysByCrewAndDateResult = try? newJSONDecoder().decode(GetFlightLegKeysByCrewAndDateResult.self, from: jsonData)

import Foundation

// MARK: - GetFlightLegKeysByCrewAndDateResult
struct GetFlightLegKeysByCrewAndDateResult: Codable {
    let id: Int
    let jsonrpc: String
    let result: [FlightLegKey]
}

