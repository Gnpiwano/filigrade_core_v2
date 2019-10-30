//
//  FiligradeErrorResponse.swift
//  filigrade_core
//
//  Created by Guus Iwanow on 29/10/2019.
//  Copyright © 2019 filigrade. All rights reserved.
//

import Foundation

public struct FiligradeErrorResponse: Decodable {
    public let error: String
    public let code: Int
    
    public init?(json dict: [String: Any]) {
        self.error = dict["Error"] as? String ?? ""
        self.code = dict["Code"] as? Int ?? 0
    }
}
