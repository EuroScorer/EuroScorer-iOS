//
//  FirebaseUserRepository.swift
//  EuroScorer
//
//  Created by Sacha DSO on 12/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import Foundation
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
        // Localize sms sent to user's laguage
        Auth.auth().languageCode = Locale.current.languageCode ?? "en"
        
        currentVerificationID = try await PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil)
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
        let idToken = try await fetchIdToken()
        network.headers["Authorization"] = idToken
        return try await network.post("/vote", body: .urlEncoded(["votes": votes]))
    }
    
    func fetchVotes() async throws -> [String] {
        let idToken = try await fetchIdToken()
        network.headers["Authorization"] = idToken
        let vote:FirebaseVote = try await network.get("/vote")
        return vote.votes
    }
    
    func logout() {
        try? Auth.auth().signOut()
    }
 
    private func fetchIdToken() async throws -> String {
        let tokenResult = try await Auth.auth().currentUser?.getIDTokenResult(forcingRefresh: true)
        return tokenResult?.token ?? ""
    }
    
    func confirmPhoneNumberWith(code: SMSCode) async throws {
        let verificationID = currentVerificationID ?? ""
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
        let _ = try await Auth.auth().signIn(with: credential)
    }
}
