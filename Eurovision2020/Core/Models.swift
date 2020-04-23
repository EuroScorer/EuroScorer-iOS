//
//  Country.swift
//  Eurovision2020
//
//  Created by Sacha DSO on 12/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import Foundation

struct User {
    var countryCode = ""
    var phoneNumber = ""
}

protocol Song {
    var number: Int { get }
    var title: String { get }
    var link: String { get }
    var country: Country? { get }
}

protocol Country {
    var code: String { get }
    var name: String { get }
}



