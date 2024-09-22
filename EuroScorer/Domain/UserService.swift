//
//  UserService.swift
//  EuroScorer
//
//  Created by Sacha Durand Saint Omer on 28/04/2023.
//  Copyright © 2023 MarsacProductions. All rights reserved.
//

import Foundation

actor UserService {
    
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func askForPhoneNumberVerification(phoneNumber: PhoneNumber) async throws {
        return try await repository.askForPhoneNumberVerification(phoneNumber: phoneNumber)
    }
    
    func getCurrentUser() async throws -> User? {
        return try await repository.getCurrentUser()
    }
    
    func sendVotes(_ votes: [String]) async throws {
        return try await repository.sendVotes(votes)
    }
    
    func fetchVotes() async throws -> [String]{
        return try await repository.fetchVotes()
    }
    
    func confirmPhoneNumberWith(code: SMSCode) async throws {
        return try await repository.confirmPhoneNumberWith(code: code)
    }
    
    func logout() async {
        await repository.logout()
    }
}
