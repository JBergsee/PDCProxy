//
//  File.swift
//  
//
//  Created by Johan Nyman on 2022-07-25.
//

import Foundation

// MARK: - CCXCrewAct

struct PDCCrewList: Codable {
    let approach: String?
    let crewList: [PDCCrew]
    let manual, takeoffNightTime, touchdownNightTime: Bool
}

// MARK: - CCXCrewAsg

public class PDCCrew: Codable, CustomStringConvertible {
    public let crewCode: String
    public let fullName: String
    public let position: String
    public let pic: Bool
    public var takeoffFlying, takeoffMonitoring, approachFlying, approachMonitoring, touchdownFlying, touchdownMonitoring: Bool
    let lineCheck, pass: [JSONAny]
    let done: [JSONAny]
    let dutyCode: String?

    init(crewCode: String,
         fullName: String,
         position: String = "",
         pic: Bool = false,
         takeoffFlying: Bool = false, takeoffMonitoring: Bool = false,
         approachFlying: Bool = false, approachMonitoring: Bool = false,
         touchdownFlying: Bool = false, touchdownMonitoring: Bool = false,
         dutyCode: String = "",
         done: [JSONAny] = [], lineCheck: [JSONAny] = [], pass: [JSONAny] = []) {
        self.crewCode = crewCode
        self.fullName = fullName
        self.position = position
        self.pic = pic
        self.takeoffFlying = takeoffFlying
        self.takeoffMonitoring = takeoffMonitoring
        self.approachFlying = approachFlying
        self.approachMonitoring = approachMonitoring
        self.touchdownFlying = touchdownFlying
        self.touchdownMonitoring = touchdownMonitoring
        self.done = done
        self.dutyCode = dutyCode
        self.lineCheck = lineCheck
        self.pass = pass
    }
    
    public var description: String {
        return "\(fullName) (\(crewCode))\nPF Takeoff: \(takeoffFlying)\nPF Landing: \(touchdownFlying)"
    }
}
