//
//  UserRepository.swift
//  EuroScorer
//
//  Created by Sacha DSO on 12/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import Foundation

typealias PhoneNumber = String
typealias SMSCode = String

protocol UserRepository: Sendable {
    func askForPhoneNumberVerification(phoneNumber: PhoneNumber) async throws
    func getCurrentUser() async throws -> User?
    func sendVotes(_ votes: [String]) async throws
    func fetchVotes() async throws -> [String]
    func confirmPhoneNumberWith(code: SMSCode) async throws
    func logout() async
}

