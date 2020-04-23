//
//  Song+UseCases.swift
//  Eurovision2020
//
//  Created by Sacha DSO on 12/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import Foundation
import Combine

typealias PhoneNumber = String
typealias SMSCode = String

struct User { }
extension User {
    
    enum Endpoint {
        static var askForPhoneNumberVerification: ((PhoneNumber) -> AnyPublisher<Void, Error>)!
        static var confirmPhoneNumberWithCode: ((SMSCode) -> AnyPublisher<Void, Error>)!
        static var getCurrentUser: (() -> UserProtocol?)!
        static var sendVotes: (([String]) -> AnyPublisher<Void, Error>)!
        static var logout: (() -> Void)!
    }
        
    static func askForPhoneNumberVerification(number: PhoneNumber) -> AnyPublisher<Void, Error> {
        User.Endpoint.askForPhoneNumberVerification(number)
    }
    
    static func confirmPhoneNumberWith(code: SMSCode) -> AnyPublisher<Void, Error> {
        User.Endpoint.confirmPhoneNumberWithCode(code)
    }
    
    static var currentUser: UserProtocol? {
        User.Endpoint.getCurrentUser()
    }
}

extension UserProtocol {
    
    func sendVotes(_ votes: [String]) -> AnyPublisher<Void, Error> {
        User.Endpoint.sendVotes(votes)
    }
    
    func logout() {
        User.Endpoint.logout()
    }
}

struct Songs {
    
    enum Endpoint {
        static var fetchSongs: (() -> AnyPublisher<[Song], Error>)!
    }

    static func fetchSongs() -> AnyPublisher<[Song], Error> {
        Songs.Endpoint.fetchSongs()
    }
}
