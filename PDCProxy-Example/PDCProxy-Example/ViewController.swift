//
//  ViewController.swift
//  PDC-sender
//
//  Created by Johan Nyman on 2022-07-21.
//

import UIKit
import PDCProxy


class ViewController: UIViewController {
    
    private var proxy: PDCProxy?
    private var token:String = "no token yet"
    @IBOutlet var tv: UITextView!
    
    @IBOutlet var datePicker:UIDatePicker!
    @IBOutlet var codeField:UITextField!
    @IBOutlet var toField:UITextField!
    @IBOutlet var ldgField:UITextField!
    
    private var currentCrew:[PDCCrew]?
    private var currentKey:FlightLegKey?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // clear text view
        self.tv.text = nil
        
        //Create proxy
        proxy = PDCProxy()
        
        datePicker.timeZone = TimeZone(identifier: "UTC")
        
    }
    
    @IBAction func version() {
        Task {
            do {
                let versions = try await proxy?.version()
                let keys = versions?.methods.map { $0.key }.sorted()
                var stringOfKeys:String = ""
                keys?.forEach { key in
                    stringOfKeys.append(contentsOf: "\(key)\n")
                }
                self.tv.text.append(contentsOf:stringOfKeys+"\n")
            } catch {
                self.tv.text.append(contentsOf: "Error: \(error.localizedDescription)\n\n")
            }
            
        }
        
    }
    
    @IBAction func login() {
        Task {
            do {
                let (token,time) = try await proxy!.login(username: "JL2PDC", password: "mx8581lmhj")
                self.tv.text.append(contentsOf: "Token: \(token)\n\nValidity: \(time)\n")
            } catch {
                self.tv.text.append(contentsOf: "Error: \(error.localizedDescription)\n\n")
                
            }
        }
    }
    
    
    @IBAction func getData() {
        Task {
            do {
                //Get date from picker
                let date = datePicker.date
                let code = codeField.text ?? ""
                (currentKey, currentCrew) = try await proxy!.getLog(flightNbr: "NVR247", date: date, dep:"ARN", dest:"CHQ", crewCode: code)
                self.tv.text.append(contentsOf: "Key: \(currentKey!)\nCrew 1: \(currentCrew!.first!)\nCrew 2: \(currentCrew!.last!)\n")
            } catch {
                self.tv.text.append(contentsOf: "Error: \(error.localizedDescription)\n\n")
            }
        }
    }
    
    
    @IBAction func postData() {
        Task {
            //Get pilots names
            let takeOffPilot = toField.text ?? ""
            let landingPilot = ldgField.text ?? ""
            let updated = PDCProxy.fix(crew: &currentCrew!, takeOffPilot: takeOffPilot, landingPilot: landingPilot)
            if updated {
                do {
                    let success = try await proxy!.setLog(key: currentKey!, crew: currentCrew!)
                    self.tv.text.append(contentsOf: "Update successful \(success)\n")
                } catch {
                    self.tv.text.append(contentsOf: "Error: \(error.localizedDescription)\n\n")
                }
            } else {
                self.tv.text.append("Wrong name(s) in takeoff/landing\n")
            }
        }
        
    }
    
}

