//
//  Market.swift
//  Technical-test
//
//  Created by Patrice MIAKASSISSA on 30.04.21.
//

import Foundation


struct Market: Codable, Equatable {
    let marketName:String
    var quotes:[Quote]?
}
