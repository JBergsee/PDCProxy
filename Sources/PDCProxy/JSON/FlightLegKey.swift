//
//  File.swift
//  
//
//  Created by Johan Nyman on 2022-07-25.
//

import Foundation

//CCXReportKey in PDC documentation

// MARK: - Key
public struct FlightLegKey: Codable {
    let arr, crewID: String
    let datop: Double
    let dep, flightID: String
    let legNo: Int

    enum CodingKeys: String, CodingKey {
        case arr
        case crewID = "crewId"
        case datop, dep
        case flightID = "flightId"
        case legNo
    }
}
