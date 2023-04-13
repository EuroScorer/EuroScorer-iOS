//
//  FirebaseImplementation.swift
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

class FirebaseUserRepository: UserRepository {
    
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
    
    private var currentVerificationID: String?
    
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
}

class FirebaseImplementation: NetworkingService {
    
    var network = NetworkingClient(baseURL: "https://euroscorer-api.web.app/v1") //"https://api.euroscorer2020.com/v1")
        
    var currentVerificationID: String?
    func confirmPhoneNumberWithCode(code: SMSCode) -> AnyPublisher<Void, Error> {
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
    
    private var cachedCurrentUser: UserProtocol?
    
    func getCurrentUser() -> UserProtocol? {
        if let cachedUser = cachedCurrentUser, Auth.auth().currentUser != nil {
            return cachedUser
        }

        if let cuPhoneNumber = Auth.auth().currentUser?.phoneNumber {
            let phoneNumberKit = PhoneNumberKit()
            let parsedNumber = try? phoneNumberKit.parse(cuPhoneNumber)
            
            if let regionID = parsedNumber?.regionID {
                let user = FirebaseUser(countryCode: regionID, phoneNumber: cuPhoneNumber)
                cachedCurrentUser = user
                return cachedCurrentUser
            }
        }

        return nil
    }
    
    func logout() {
        try? Auth.auth().signOut()
    }
    

    func sendVotes(_ votes:[String]) -> AnyPublisher<Void, Error> {
        fetchIdToken().then { [unowned self] idToken in
            self.network.headers["Authorization"] = idToken
            return self.network.post("/vote", params: ["votes": votes])
        }.eraseToAnyPublisher()
    }
    
    func fetchVotes() -> AnyPublisher<[String], Error> {
        fetchIdToken().then { [unowned self] idToken in
            self.network.headers["Authorization"] = idToken
            return self.network.get("/vote").map { (vote: FirebaseVote) -> [String] in
                return vote.votes
            }.eraseToAnyPublisher()
        }.eraseToAnyPublisher()
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
}
