//
//  FiligradeRegisterApi.swift
//  filigrade_core
//
//  Created by Guus Iwanow on 24/10/2019.
//  Copyright © 2019 filigrade. All rights reserved.
//

import Foundation

open class FiligradeRegisterApi {

    let requestHandler: FiligradeRequestHandler

    public init(handler: FiligradeRequestHandler) {
        self.requestHandler = handler
    }
    
    public func getRegistrationStatus(deviceIdentifier: String, handler: @escaping ((GETRegistrationStatusResponse) -> Void)) {
        let path = "/register/" + deviceIdentifier
        
        requestHandler.request(path: path) { (data, response, error) in
            switch response?.statusCode {
            case 200: handler(.success)
            case 404: handler(.thisDeviceIsNotRegistered())
            default: handler(.genericErrorResponse())
            }
        }
    }
    
    public func putDeviceRegistration(
        deviceIdentifier: String,
        preauth: Bool,
        registrationData: DeviceRegistrationBody,
        handler: @escaping ((PutRegistrationResponse) -> Void)) {
        
        let path = "/register/" + deviceIdentifier
        let params = preauth ? ["preauth": "true"] : [:]
        let body = registrationData.getHttpBody()
        
        requestHandler.request(path: path, params: params, method: .put, body: body) { (data, response, error) in
            switch response?.statusCode {
                case 200: handler(.success)
                case 404: handler(.noPreauthorizationRecordExists())
                default: handler(.genericErrorResponse())
            }
        }
    }
}

public enum GETRegistrationStatusResponse {
    case success
    case thisDeviceIsNotRegistered(responseCode: Int = 404)
    case emailNotBeenValidated(responseCode: Int = 423)
    case genericErrorResponse(responseCode: Int = 500)
}

public enum PutRegistrationResponse {
    case success
    case noPreauthorizationRecordExists(responseCode: Int = 404)
    case genericErrorResponse(responseCode: Int = 500)
}
