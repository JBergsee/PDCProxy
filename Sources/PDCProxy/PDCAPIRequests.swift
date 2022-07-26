//
//  APIMethodsRequest.swift
//  PDC-sender
//
//  Created by Johan Nyman on 2022-07-21.
//

import Foundation

extension VersionRequest {

    func dispatch(
        onSuccess successHandler: @escaping ((_: VersionResult) -> Void),
        onFailure failureHandler: @escaping ((_: PDCError?, _: Error) -> Void)) {

        PDCAPIRequest.post(
            request: self,
            onSuccess: successHandler,
            onError: failureHandler)
    }
}

extension LoginRequest {

    func dispatch(
        onSuccess successHandler: @escaping ((_: LoginResult) -> Void),
        onFailure failureHandler: @escaping ((_: PDCError?, _: Error) -> Void)) {

        PDCAPIRequest.post(
            request: self,
            onSuccess: successHandler,
            onError: failureHandler)
    }
}

extension GetFlightLegKeysByCrewAndDateRequest {

    func dispatch(
        onSuccess successHandler: @escaping ((_: GetFlightLegKeysByCrewAndDateResult) -> Void),
        onFailure failureHandler: @escaping ((_: PDCError?, _: Error) -> Void)) {

        PDCAPIRequest.post(
            request: self,
            onSuccess: successHandler,
            onError: failureHandler)
    }
}

extension GetPilotsLogRequest {

    func dispatch(
        onSuccess successHandler: @escaping ((_: GetPilotsLogResult) -> Void),
        onFailure failureHandler: @escaping ((_: PDCError?, _: Error) -> Void)) {

        PDCAPIRequest.post(
            request: self,
            onSuccess: successHandler,
            onError: failureHandler)
    }
}

extension SetPilotsLogRequest {

    func dispatch(
        onSuccess successHandler: @escaping ((_: SetPilotsLogResult) -> Void),
        onFailure failureHandler: @escaping ((_: PDCError?, _: Error) -> Void)) {

        PDCAPIRequest.post(
            request: self,
            onSuccess: successHandler,
            onError: failureHandler)
    }
}
