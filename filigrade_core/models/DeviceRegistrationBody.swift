//
//  DeviceRegistrationBody.swift
//  filigrade_core
//
//  Created by Guus Iwanow on 24/10/2019.
//  Copyright © 2019 filigrade. All rights reserved.
//

import Foundation

public struct DeviceRegistrationBody {
    let user: String
    let email: String
    let company: String
    
    public init(user: String, email: String, company: String) {
        self.user = user
        self.email = email
        self.company = company
    }
    
    func getHttpBody() -> [String: String] {
        return [
            "User": self.user,
            "Email": self.email,
            "Company": self.company
        ]
    }
}

/*
 "User":"Guus Iwanow",
 "Email":"g.iwanow@filigrade.com",
 "Company":"FiliGrade"
 */
