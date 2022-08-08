//
//  File.swift
//  
//
//  Created by Johan Nyman on 2022-07-24.
//

import Foundation

public class PDCProxy {
    
    private var username: String
    private var password: String
    
    private var token: String?
    private var timeLimit: Double?
    
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    public func version() async throws -> PDCVersion {
        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<PDCVersion, Error>) in
            
            VersionRequest()
                .dispatch(
                    onSuccess: { (successResponse) in
                        continuation.resume(returning: successResponse.result)
                    },
                    onFailure: { (errorResponse, error) in
                        //Check the error and rethrow correct one
                        if let pdcError = errorResponse {
                            continuation.resume(throwing: pdcError.result.createNSError())
                        } else {
                            continuation.resume(throwing: error)
                        }
                    }
                )
        })
    }
    
    public func login(crewmember:Bool = false) async throws -> (token: String, expiry: Date) {
        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<(String,Date), Error>) in
            
            LoginRequest(params: LoginParams(username: username, password: password, crewmemberLogin: crewmember))
                .dispatch(
                    onSuccess: { (successResponse) in
                        //Save token and timeOffset
                        self.token = successResponse.result.authentication
                        self.timeLimit = successResponse.result.limit
                        let expiryDate = Date(timeIntervalSince1970: (self.timeLimit ?? 0)/1000)
                        continuation.resume(returning: (successResponse.result.authentication, expiryDate))
                    },
                    onFailure: { (errorResponse, error) in
                        //Check the error and rethrow correct one
                        if let pdcError = errorResponse {
                            continuation.resume(throwing: pdcError.result.createNSError())
                        } else {
                            continuation.resume(throwing: error)
                        }
                    })
        })
    }
    
    func getFlightLegKeys(crewCode: String, date: Date) async throws -> [FlightLegKey] {
        
        let datop = pdcOffset(date)
        
        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<[FlightLegKey], Error>) in
            
            let params = FlightLegKeysByCrewAndDateParams(authentication: token ?? "[no token]", crewID: crewCode, datop: datop)
            GetFlightLegKeysByCrewAndDateRequest(params: params)
                .dispatch(
                    onSuccess: { (successResponse) in
                        continuation.resume(returning: (successResponse.result))
                    },
                    onFailure: { (errorResponse, error) in
                        //Check the error and rethrow correct one
                        if let pdcError = errorResponse {
                            continuation.resume(throwing: pdcError.result.createNSError())
                        } else {
                            continuation.resume(throwing: error)
                        }
                    })
        })
    }
    
    public func getLog(flightNbr: String, date: Date, dep: String, dest: String, crewCode: String) async throws -> (FlightLegKey, [PDCCrew]) {
        
        var keys:[FlightLegKey]
        
        do {
            //Get keys for crew and date
            keys = try await getFlightLegKeys(crewCode: crewCode, date: date)
        } catch {
            throw error
        }
        
        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<(FlightLegKey, [PDCCrew]), Error>) in
            
            //Find the key where dep and dest are consistent with params
            let key = keys.first { leg in
                return leg.dep == dep && leg.arr == dest
                //Eventually also check flight nbr (without padding 0) if several flights between
                //same city pair on the same day...
            }
            //Make sure we got one key
            guard let key = key else {
                continuation.resume(throwing: PDCAPIRequest.APIError.noData)
                return
            }
            
            //get legData
            let params = PilotsLogParams(authentication: token ?? "[invalid token]", key: key)
            
            GetPilotsLogRequest(params: params)
                .dispatch(
                    onSuccess: { (successResponse) in
                        let list = successResponse.result.crewList
                        continuation.resume(returning: (key,list))
                    },
                    onFailure: { (errorResponse, error) in
                        //Check the error and rethrow correct one
                        if let pdcError = errorResponse {
                            continuation.resume(throwing: pdcError.result.createNSError())
                        } else {
                            continuation.resume(throwing: error)
                        }
                    })
        })
    }
    
    public func setLog(key: FlightLegKey, crew:[PDCCrew]) async throws -> Bool {
                
        return try await withCheckedThrowingContinuation({ (continuation: CheckedContinuation<Bool, Error>) in
                        
            //construct Params
            let list = PDCCrewList(approach: "", crewList: crew, manual: true, takeoffNightTime: false, touchdownNightTime: false)
            let params = SetPilotsLogParams(authentication: token ?? "[invalid token]", key: key, value: list)
            
            SetPilotsLogRequest(params: params)
                .dispatch(
                    onSuccess: { (successResponse) in
                        //Result is a string stating "Update Succeeded / Update Failed"
                        continuation.resume(returning: successResponse.result == "Update Succeeded")
                    },
                    onFailure: { (errorResponse, error) in
                        //Check the error and rethrow correct one
                        if let pdcError = errorResponse {
                            continuation.resume(throwing: pdcError.result.createNSError())
                        } else {
                            continuation.resume(throwing: error)
                        }
                    })
        })
    }
    
    //Returns false if takeoff or landing pilot not found
    public static func setPFPM(crew: inout [PDCCrew], takeOffPilot: String, landingPilot: String) -> Bool {
        
        var pfTO: Bool = false
        var pfLDG: Bool = false
        
        for i in 0...crew.count-1 {
            //Takeoff
            if crew[i].fullName.compare(takeOffPilot, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame {
                pfTO = true
                crew[i].takeoffFlying = true
                crew[i].takeoffMonitoring = false
            } else {
                crew[i].takeoffFlying = false
                crew[i].takeoffMonitoring = true
            }
            //Landing
            if crew[i].fullName.compare(landingPilot, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame {
                pfLDG = true
                crew[i].approachFlying = true
                crew[i].approachMonitoring = false
                crew[i].touchdownFlying = true
                crew[i].touchdownMonitoring = false
            } else {
                crew[i].approachFlying = false
                crew[i].approachMonitoring = true
                crew[i].touchdownFlying = false
                crew[i].touchdownMonitoring = true
            }
        }
        return pfTO && pfLDG == true
    }
    
    private func pdcOffset(_ date: Date) -> Double {
        //PDC rounds the date to the closest midnight,
        //so strip time
        guard let dateOnly = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: date)) else {
            fatalError("Failed to strip time from Date object")
        }
            
        return dateOnly.timeIntervalSince1970 * 1000
    }
}
