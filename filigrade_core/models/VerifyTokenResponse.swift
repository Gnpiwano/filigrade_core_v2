//
//  VerifyTokenResponse.swift
//  filigrade_core
//
//  Created by Guus Iwanow on 29/10/2019.
//  Copyright © 2019 filigrade. All rights reserved.
//

import Foundation

public struct VerifyTokenResponse: Decodable {
    public let id: String
    public let IsConclusive: Bool
    public let IsOriginal: Bool
    public let message: String
    
    public init?(json dict: [String: Any]) {
        guard let verifyDataDict = dict["Result"] as? [String: Any] else { return nil }
               
        self.id = verifyDataDict["Id"] as? String ?? ""
        self.IsConclusive = verifyDataDict["IsConclusive"] as? Bool ?? false
        self.IsOriginal = verifyDataDict["IsOriginal"] as? Bool ?? false
        self.message = verifyDataDict["Message"] as? String ?? ""
    }
}
