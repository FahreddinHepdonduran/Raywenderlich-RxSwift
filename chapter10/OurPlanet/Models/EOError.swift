//
//  EOError.swift
//  OurPlanet
//
//  Created by fahreddin on 16.02.2021.
//  Copyright © 2021 fahreddin. All rights reserved.
//

import Foundation

enum EOError: Error {
    case invalidURL(String)
    case invalidParameter(String, Any)
    case invalidJSON(String)
    case invalidDecoderConfiguration
}
