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
}
