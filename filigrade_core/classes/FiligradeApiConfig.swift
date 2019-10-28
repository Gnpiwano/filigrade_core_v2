//
//  FiligradeApiConfig.swift
//  filigrade_core
//
//  Created by Guus Iwanow on 21/10/2019.
//  Copyright © 2019 filigrade. All rights reserved.
//

import Foundation

public struct FiligradeApiConfig {
    let baseURL: String
    let appID: String
    let secretKey: String
    let acceptLanguage: String?
    
    public init(baseURL: String, appID: String, secretKey: String, acceptLanguage: String? = nil) {
        self.baseURL = baseURL
        self.appID = appID
        self.secretKey = secretKey
        self.acceptLanguage = acceptLanguage
    }
}
