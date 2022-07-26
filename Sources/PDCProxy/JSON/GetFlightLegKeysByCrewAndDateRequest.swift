//
//  GetFlightLegKeysByCrewAndDate.swift
//  PDC-sender
//
//  Created by Johan Nyman on 2022-07-23.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let getFlightLegKeysByCrewAndDate = try? newJSONDecoder().decode(GetFlightLegKeysByCrewAndDate.self, from: jsonData)

import Foundation

// MARK: - GetFlightLegKeysByCrewAndDate
class GetFlightLegKeysByCrewAndDateRequest: Codable {
    private var jsonrpc: String = "2.0"
    private var id: Int = 3
    private var method: String = "getFlightLegKeysByCrewAndDate"
    let params: FlightLegKeysByCrewAndDateParams
    
    init(params: FlightLegKeysByCrewAndDateParams) {
        self.params = params
    }
}

// MARK: - Params
struct FlightLegKeysByCrewAndDateParams: Codable {
    let authentication, crewID: String
    let datop: Double

    enum CodingKeys: String, CodingKey {
        case authentication
        case crewID = "crewId"
        case datop
    }
}
