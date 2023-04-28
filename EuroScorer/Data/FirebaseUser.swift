//
//  FirebaseUser.swift
//  EuroScorer
//
//  Created by Sacha Durand Saint Omer on 12/04/2023.
//  Copyright © 2023 MarsacProductions. All rights reserved.
//

import Foundation

struct FirebaseUser {
    let countryCode: String
    let phoneNumber: String
}

extension FirebaseUser {
    func toUser() -> User {
        return User(countryCode: countryCode, phoneNumber: phoneNumber)
    }
}
