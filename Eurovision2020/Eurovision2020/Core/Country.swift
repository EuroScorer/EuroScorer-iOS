//
//  Country.swift
//  Eurovision2020
//
//  Created by Sacha DSO on 12/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import Foundation

struct Country {
    static var countries = [Country]()
    
    public init() {}
    public init(code: String, name: String) {
        self.code = code
        self.name = name
    }
    var code = ""
    var name = ""
}


