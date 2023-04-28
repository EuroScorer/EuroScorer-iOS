//
//  FirebaseUserRepository.swift
//  EuroScorer
//
//  Created by Sacha DSO on 12/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import Foundation
import Combine
import Networking
import Firebase
import PhoneNumberKit
import FirebaseRemoteConfig

class FirebaseUserRepository: UserRepository, NetworkingService {
    
    var network = NetworkingClient(baseURL: "https://euroscorer-api.web.app/v1") //"https://api.euroscorer2020.com/v1")
    
    var currentVerificationID: String?
    
    init() {
        FirebaseApp.configure()
        
        // Get latest remote config data.
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.fetch(withExpirationDuration: 0) { status, error in
            if error == nil {
                remoteConfig.activate(completion: nil)
            }
        }
    }
    
    func askForPhoneNumberVerification(phoneNumber: PhoneNumber) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            // Localize sms sent to user's laguage
            Auth.auth().languageCode = Locale.current.languageCode ?? "en"
            // Start SMS confirmation
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationID, error in
                    if let e = error {
                        continuation.resume(with: .failure(e))
                    } else {
                        self?.currentVerificationID = verificationID
                        continuation.resume(with: .success(()))
                    }
            }
        }
    }
    
    private var cachedCurrentUser: User?
    
    func getCurrentUser() -> User? {
        if let cachedUser = cachedCurrentUser, Auth.auth().currentUser != nil {
            return cachedUser
        }

        if let cuPhoneNumber = Auth.auth().currentUser?.phoneNumber {
            let phoneNumberKit = PhoneNumberKit()
            let parsedNumber = try? phoneNumberKit.parse(cuPhoneNumber)
            
            if let regionID = parsedNumber?.regionID {
                let user = FirebaseUser(countryCode: regionID, phoneNumber: cuPhoneNumber)
                cachedCurrentUser = user.toUser()
                return cachedCurrentUser
            }
        }

        return nil
    }
    
    func sendVotes(_ votes: [String]) async throws {
        let idToken = try await fetchIdTokenAsync()
        network.headers["Authorization"] = idToken
        return try await network.post("/vote", params: ["votes": votes])
    }
    
    func fetchVotes() -> AnyPublisher<[String], Error> {
        fetchIdToken().then { [unowned self] idToken in
            self.network.headers["Authorization"] = idToken
            return self.network.get("/vote").map { (vote: FirebaseVote) -> [String] in
                return vote.votes
            }.eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
    
    func logout() {
        try? Auth.auth().signOut()
    }
    
    private func fetchIdToken() -> Future<String, Error> {
        Future<String, Error> { promise in
            Auth.auth().currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                if let error = error {
                    promise(.failure(error))
                } else if let idToken = idToken {
                    promise(.success(idToken))
                }
            }
        }
    }
    
    private func fetchIdTokenAsync() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            Auth.auth().currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let idToken = idToken {
                    continuation.resume(returning: idToken)
                }
            }
        }
    }
    
    func confirmPhoneNumberWith(code: SMSCode) -> AnyPublisher<Void, Error> {
        let verificationID = currentVerificationID ?? ""
        return Future { promise in
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
            Auth.auth().signIn(with: credential) { _, error in
                if let e = error {
                    promise(.failure(e))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
}
