//
//  PDCProxyTests.swift
//  
//
//  Created by Johan Nyman on 2022-07-25.
//

import XCTest
@testable import PDCProxy

class PDCProxyTests: XCTestCase {

    var proxy: PDCProxy!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        proxy = PDCProxy(username: "JL2PDC", password: "mx8581lmhj")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        proxy = nil
        try super.tearDownWithError()
    }

    
    func testVersion() async throws {
    
        do {
            let version = try await proxy.version()
            XCTAssert(version.methods.count > 10, "No methods")
        } catch {
            XCTFail("Error caught: \(error)")
        }
    }
    
    func testLogin() async throws {
        
        //Test wrong pwd
        do {
            let wrongProxy = PDCProxy(username: "No", password: "Neither")
            let (_, _) = try await wrongProxy.login()
            XCTFail("Got token from wrong password.")
        } catch {
            print("Error thrown correctly: \(error)")
            let failureDescription = error.localizedDescription
            XCTAssert(failureDescription.contains("Username or Password is incorrect"), "Login with wrong user/pwd")
        }
        //Test correct password
        do {
            let (token, validity) = try await proxy.login()
            XCTAssert(token.count > 50, "No token")
            print(validity)
            XCTAssert(validity.timeIntervalSinceNow > 60*59, "Short or no validity")
        } catch {
            XCTFail("Error caught: \(error)")
        }
    }
    
    func testGetKeys() async throws {
        let cal = Calendar(identifier: .gregorian)
        let dof = cal.date(from: DateComponents( year: 2022, month: 10, day: 24, hour: 23, minute: 50))! //Let time be after UTC midday.
        //The local date is 25th, while UTC date is 24th
        let crewCode = "HOJ"
        
        do {
            //login first
            _ = try await proxy.login()
            let keys = try await proxy.getFlightLegKeys(crewCode: crewCode, date: dof)
            XCTAssert(keys.count == 2, "No flights")
        } catch {
            XCTFail("Error caught: \(error)")
        }
    }
    
    func testGetPilotsLog() async throws {
        let cal = Calendar(identifier: .gregorian)
        let dof = cal.date(from: DateComponents( year: 2022, month: 10, day: 24, hour: 23, minute: 50))!
        let testCode = "HOJ"
        let testCrewName = "Joakim Högbom"
        let testDep = "PVK"
        let testDest = "CPH"
        
        //login first
        _ = try! await proxy.login()
        
        do {
            //wrong flight
            _ = try await proxy.getLog(flightNbr: "", date: dof, dep: "CHQ", dest: "BLL", crewCode: testCode)
            XCTFail("Got flight from erroneous data.")
        } catch {
            let failureDescription = error.localizedDescription
            print("Error thrown correctly: \(error)")
            XCTAssert(failureDescription == "PDC found no flight. Please report PF/PM manually.", "Wrong error")
        }
        
        do {
            //existing flight
            let (_,crewList) = try await proxy.getLog(flightNbr: "shouldn't matter", date: dof, dep: testDep, dest: testDest, crewCode: testCode)
            let crew = crewList.first { $0.crewCode == testCode }!
            XCTAssert(crew.fullName == testCrewName, "Wrong flight")
        } catch {
            XCTFail("Error caught: \(error)")
        }
    }
    
    func testPFPM() {
        let pilot1 = PDCCrew(crewCode: "ART", fullName: "Therese Miles")
        
        let pilot2 = PDCCrew(crewCode: "XXX", fullName: "ÅÄÖ och cASÉ")
        
        
        var crewList = [pilot1,pilot2]
        
        XCTAssertTrue(PDCProxy.setPFPM(crew: &crewList, takeOffPilot: "Therese Miles", landingPilot: "AAO OCH CASE"), "Update failed")
        
        XCTAssert(crewList[0].takeoffFlying == true)
        XCTAssert(crewList[0].takeoffMonitoring == false)
        XCTAssert(crewList[0].approachFlying == false)
        XCTAssert(pilot1.approachMonitoring == true)
        XCTAssert(pilot1.touchdownFlying == false)
        XCTAssert(pilot1.touchdownMonitoring == true)
        
        XCTAssert(pilot2.takeoffFlying == false)
        XCTAssert(pilot2.takeoffMonitoring == true)
        XCTAssert(pilot2.approachFlying == true)
        XCTAssert(pilot2.approachMonitoring == false)
        XCTAssert(pilot2.touchdownFlying == true)
        XCTAssert(pilot2.touchdownMonitoring == false)

        //Test with misspelled name
        XCTAssertFalse(PDCProxy.setPFPM(crew: &crewList, takeOffPilot: "Therese Miles", landingPilot: "AAEOO och cASé"), "Update didn't fail! (when it should)")
        
        XCTAssert(crewList[0].takeoffFlying == true)
        XCTAssert(crewList[0].takeoffMonitoring == false)
        XCTAssert(crewList[0].approachFlying == false)
        XCTAssert(pilot1.approachMonitoring == true)
        XCTAssert(pilot1.touchdownFlying == false)
        XCTAssert(pilot1.touchdownMonitoring == true)
        
        XCTAssert(pilot2.takeoffFlying == false)
        XCTAssert(pilot2.takeoffMonitoring == true)
        XCTAssert(pilot2.approachFlying == false)
        XCTAssert(pilot2.approachMonitoring == true)
        XCTAssert(pilot2.touchdownFlying == false)
        XCTAssert(pilot2.touchdownMonitoring == true)
    }
}




