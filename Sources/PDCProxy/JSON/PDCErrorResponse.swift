//
//  PDCErrorResponse.swift
//  PDC-sender
//
//  Created by Johan Nyman on 2022-07-23.
//


// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let pDCError = try? newJSONDecoder().decode(PDCError.self, from: jsonData)

import Foundation

// MARK: - PDCError
struct PDCError: Codable {
    let id: Int
    let jsonrpc: String
    let result: ErrorResult
    //let error: ErrorResult
}


// MARK: - Result
struct ErrorResult: Codable, CustomStringConvertible {
    let error: DeepError?
    let code: Int?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case error = "Error"
        case code
        case message
    }
    
    var description: String {
        if let error = error {
            return error.description
        }
        return "\(message ?? "[Unknown error]") (\(code ?? 0))"
    }
    
    func createNSError(function: String = #function, file: String = #file, line: Int = #line) -> NSError {
        
        let domain = "PDCProxy"
        
        let functionKey = "\(domain).function"
        let fileKey = "\(domain).file"
        let lineKey = "\(domain).line"
        
        let error = NSError(domain: domain, code: code ?? 999, userInfo: [
            NSLocalizedDescriptionKey: description,
            functionKey: function,
            fileKey: file,
            lineKey: line
        ])
        
        return error
    }
}

// MARK: - Error
class DeepError: Codable, CustomStringConvertible {
    
    let alertText: String
    let allowContinue: Bool
    let kindOfAlert: String

    init(alertText: String, allowContinue: Bool, kindOfAlert: String) {
        self.alertText = alertText
        self.allowContinue = allowContinue
        self.kindOfAlert = kindOfAlert
    }
    
    var description: String {
        return alertText
    }
}
