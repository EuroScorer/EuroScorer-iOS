//
//  UserService.swift
//  EuroScorer
//
//  Created by Sacha Durand Saint Omer on 28/04/2023.
//  Copyright © 2023 MarsacProductions. All rights reserved.
//

import Foundation
import Combine

class UserService {
    
    private let repository: UserRepository
    
    init(repository: UserRepository) {
        self.repository = repository
    }
    
    func askForPhoneNumberVerification(phoneNumber: PhoneNumber) async throws {
        return try await repository.askForPhoneNumberVerification(phoneNumber: phoneNumber)
    }
    
    func getCurrentUser() -> User? {
        return repository.getCurrentUser()
    }
    
    func sendVotes(_ votes: [String]) async throws {
        return try await repository.sendVotes(votes)
    }
    
    func fetchVotes() -> AnyPublisher<[String], Error> {
        return repository.fetchVotes()
    }
    
    func confirmPhoneNumberWith(code: SMSCode) -> AnyPublisher<Void, Error> {
        return repository.confirmPhoneNumberWith(code: code)
    }
    
    func logout() {
        repository.logout()
    }
}
