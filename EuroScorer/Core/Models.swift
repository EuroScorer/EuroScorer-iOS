//
//  Country.swift
//  EuroScorer
//
//  Created by Sacha DSO on 12/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import Foundation

protocol UserProtocol {
    var countryCode: String { get }
    var phoneNumber: String { get }
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



