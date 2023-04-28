//
//  UserRepository.swift
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
    func getCurrentUser() -> User?
    func sendVotes(_ votes: [String]) -> AnyPublisher<Void, Error>
    func fetchVotes() -> AnyPublisher<[String], Error>
    func confirmPhoneNumberWith(code: SMSCode) -> AnyPublisher<Void, Error>
    func logout()
}

