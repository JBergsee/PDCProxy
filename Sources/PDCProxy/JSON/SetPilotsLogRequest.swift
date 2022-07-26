//
//  File.swift
//  
//
//  Created by Johan Nyman on 2022-07-25.
//

import Foundation

// MARK: - SetLogData
class SetPilotsLogRequest: Codable {
    private var jsonrpc: String = "2.0"
    private var id: Int = 5
    private var method: String = "setPilotsLogCrewData"
    let params: SetPilotsLogParams
    
    init(params: SetPilotsLogParams) {
        self.params = params
    }
}

// MARK: - Params
struct SetPilotsLogParams: Codable {
    let authentication: String
    let key: FlightLegKey
    let value: PDCCrewList
}
