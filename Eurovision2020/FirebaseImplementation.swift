//
//  FirebaseImplementation.swift
//  Eurovision2020
//
//  Created by Sacha DSO on 12/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import Foundation
import Combine
import Networking
import Firebase
import PhoneNumberKit

class FirebaseImplementation: NetworkingService {
    
    var network = NetworkingClient(baseURL: "https://us-central1-eurovision2020-ea486.cloudfunctions.net/api/v1")
    
    func fetchSongs() -> AnyPublisher<[Song], Error> {
        get("/songs")
    }
    
    func sendVotes(_ votes:[String]) -> AnyPublisher<Void, Error> {
        fetchIdToken().then { [unowned self] idToken in
            self.network.headers["Authorization"] = idToken
            return self.network.post("/vote", params: ["votes": votes])
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
    
    private var cachedCurrentUser: User?
    
    func getCurrentUser() -> User? {
        if let cachedUser = cachedCurrentUser, Auth.auth().currentUser != nil {
            return cachedUser
        }

        if let cuPhoneNumber = Auth.auth().currentUser?.phoneNumber {
            let phoneNumberKit = PhoneNumberKit()
            let parsedNumber = try? phoneNumberKit.parse(cuPhoneNumber)
            
            if let regionID = parsedNumber?.regionID {
                let user = User(countryCode: regionID, phoneNumber: cuPhoneNumber)
                cachedCurrentUser = user
                return cachedCurrentUser
            }
        }

        return nil
    }
}

extension Song: NetworkingJSONDecodable {}
