//
//  User+UserCases.swift
//  Eurovision2020
//
//  Created by Sacha DSO on 22/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import Foundation


extension User {
    
    enum Endpoint {
         static var getCurrentUser: (() -> User?)!
    }
    
    static var currentUser: User? {
        User.Endpoint.getCurrentUser!()
    }
}

