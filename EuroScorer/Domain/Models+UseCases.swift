//
//  Song+UseCases.swift
//  EuroScorer
//
//  Created by Sacha DSO on 12/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import Foundation
import Combine

typealias PhoneNumber = String
typealias SMSCode = String

protocol UserRepository {
    func askForPhoneNumberVerification(phoneNumber: PhoneNumber) async throws
}

class UserService {
    
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func askForPhoneNumberVerification(phoneNumber: PhoneNumber) async throws {
        return try await repository.askForPhoneNumberVerification(phoneNumber: phoneNumber)
    }
}

struct User { }
extension User {
    
    enum Endpoint {
        static var confirmPhoneNumberWithCode: ((SMSCode) -> AnyPublisher<Void, Error>)!
        static var getCurrentUser: (() -> UserProtocol?)!
        static var sendVotes: (([String]) -> AnyPublisher<Void, Error>)!
        static var fetchVotes: (() -> AnyPublisher<[String], Error>)!
        static var logout: (() -> Void)!
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
    
    func fetchVotes() -> AnyPublisher<[String], Error> {
        User.Endpoint.fetchVotes()
    }
    
    func logout() {
        User.Endpoint.logout()
    }
}
