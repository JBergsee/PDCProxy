//
//  GetPilotsLogRequest.swift
//  PDC-sender
//
//  Created by Johan Nyman on 2022-07-21.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let getPilotsLogRequest = try? newJSONDecoder().decode(GetPilotsLogRequest.self, from: jsonData)

import Foundation

// MARK: - GetPilotsLogRequest
class GetPilotsLogRequest: Codable {
    private var jsonrpc: String = "2.0"
    private var id: Int = 4
    private var method: String = "getPilotsLogCrewData"
    let params: PilotsLogParams

    init(params: PilotsLogParams) {
        self.params = params
    }
}

// MARK: - Params
struct PilotsLogParams: Codable {
    let authentication: String
    let key: FlightLegKey
}

