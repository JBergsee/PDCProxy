//
//  APIRequest.swift
//  PDC-sender
//
//  Created by Johan Nyman on 2022-07-21.
// (see https://medium.com/swift2go/minimal-swift-api-client-9ea1c9c7946
// for usage)

import Foundation

class PDCAPIRequest {
    
    static let endpoint:String = "https://nvrweb3.pdc.com/PDCCrew2"
    
    struct ErrorResponse: Codable {
        let status: String
        let code: Int
        let message: String
    }
    
    enum APIError: Error, LocalizedError {
        case invalidEndpoint
        case errorResponseDetected
        case noData
        
        public var errorDescription: String? {
            switch self {
            case .noData:
                return NSLocalizedString("No data found.", comment: "No data")
                
            default:
                return NSLocalizedString("PDC Error.", comment: "PDC Error")
            }
        }
    }
}

//MARK: - URL Request

extension PDCAPIRequest {
    public static func urlRequest(from request: Codable) -> URLRequest? {
        
        guard let endpointUrl = URL(string: endpoint) else {
            return nil
        }
        
        var endpointRequest = URLRequest(url: endpointUrl)
        endpointRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        return endpointRequest
    }
}


//MARK: - POST

extension PDCAPIRequest {
    public static func post<R: Codable, T: Codable, E: Codable>(
        request: R,
        onSuccess: @escaping ((_: T) -> Void),
        onError: @escaping ((_: E?, _: Error) -> Void)) {
            
            guard var endpointRequest = self.urlRequest(from: request) else {
                onError(nil, APIError.invalidEndpoint)
                return
            }
            endpointRequest.httpMethod = "POST"
            endpointRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                endpointRequest.httpBody = try JSONEncoder().encode(request)
            } catch {
                onError(nil, error)
                return
            }
            
            URLSession.shared.dataTask(
                with: endpointRequest,
                completionHandler: { (data, urlResponse, error) in
                    DispatchQueue.main.async {
                        self.processResponse(data, urlResponse, error, onSuccess: onSuccess, onError: onError)
                    }
                }).resume()
        }
}

//MARK: - Process response

extension PDCAPIRequest {
    public static func processResponse<T: Codable, E: Codable>(
        _ dataOrNil: Data?,
        _ urlResponseOrNil: URLResponse?,
        _ errorOrNil: Error?,
        onSuccess: ((_: T) -> Void),
        onError: ((_: E?, _: Error) -> Void)) {
            
            if let data = dataOrNil {
                //print("Received data:")
                //print(String(data: data, encoding: .utf8) ?? "Unable to turn data to string.")
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    onSuccess(decodedResponse)
                } catch {
                    let originalError = error
                    
                    do {
                        let errorResponse = try JSONDecoder().decode(E.self, from: data)
                        onError(errorResponse, APIError.errorResponseDetected)
                    } catch {
                        print("Unable to parse data to both object and error.")
                        print(String(data: data, encoding: .utf8) ?? "Unable to turn data to string.")
                        onError(nil, originalError)
                    }
                }
            } else {
                onError(nil, errorOrNil ?? APIError.noData)
            }
        }
}
