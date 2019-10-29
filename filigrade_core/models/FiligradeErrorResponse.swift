//
//  FiligradeErrorResponse.swift
//  filigrade_core
//
//  Created by Guus Iwanow on 29/10/2019.
//  Copyright © 2019 filigrade. All rights reserved.
//

import Foundation

struct FiligradeErrorResponse: Decodable {
    let error: String
    let code: Int
}

/*
 {
     "Error": "Could not align",
     "Code": 91
 }
 */
