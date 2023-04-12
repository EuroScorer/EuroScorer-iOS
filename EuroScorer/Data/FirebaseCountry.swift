//
//  FirebaseCountry.swift
//  EuroScorer
//
//  Created by Sacha Durand Saint Omer on 12/04/2023.
//  Copyright © 2023 MarsacProductions. All rights reserved.
//

import Foundation

struct FirebaseCountry: Country, Decodable {
    let code: String
    let name: String
}
