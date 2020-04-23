//
//  User+UserCases.swift
//  Eurovision2020
//
//  Created by Sacha DSO on 22/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import Foundation
import Combine

typealias PhoneNumber = String
typealias SMSCode = String

extension User {
    
    enum Endpoint {
        static var askForPhoneNumberVerification: ((PhoneNumber) -> AnyPublisher<Void, Error>)!
        static var confirmPhoneNumberWithCode: ((SMSCode) -> AnyPublisher<Void, Error>)!
        static var getCurrentUser: (() -> User?)!
        static var logout: (() -> Void)!
    }
        
    static func askForPhoneNumberVerification(number: PhoneNumber) -> AnyPublisher<Void, Error> {
        User.Endpoint.askForPhoneNumberVerification(number)
    }
    
    static func confirmPhoneNumberWith(code: SMSCode) -> AnyPublisher<Void, Error> {
        User.Endpoint.confirmPhoneNumberWithCode(code)
    }
    
    static var currentUser: User? {
        User.Endpoint.getCurrentUser()
    }
    
    func logout() {
        User.Endpoint.logout()
    }
}

