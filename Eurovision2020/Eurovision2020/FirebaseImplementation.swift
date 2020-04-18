//
//  FirebaseImplementation.swift
//  Eurovision2020
//
//  Created by Sacha DSO on 12/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import Foundation
import FirebaseFirestore
import Combine
import Networking
import FirebaseAuth

class FirebaseImplementation: NetworkingService {
    
    var cancellables = Set<AnyCancellable>()
    
    var network: NetworkingClient = {
        var client = NetworkingClient(baseURL: "https://us-central1-eurovision2020-ea486.cloudfunctions.net/api/v1")
        client.logLevels = .debug
        return client
    }()
    
    func fetchSongs() -> AnyPublisher<[Song], Error> {
        get("/songs")
    }
    
    func sendVotes(_ votes:[String]) -> AnyPublisher<Void, Error> {
        
        return Future<Void, Error> { promise in
            let currentUser = Auth.auth().currentUser
            currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                print(idToken)
                print(error)
                if let error = error {
                    promise(.failure(error))
                    return
                }
                self.network.headers["Authorization"] = idToken
                self.network.post("/vote", params: ["votes": votes]).then {
                    print("OK")
                    promise(.success(()))
                }.onError { error in
                    promise(.failure(error))
                }.sinkAndStore(in: &self.cancellables)
            }
        }.eraseToAnyPublisher()
    }
}

extension Song: NetworkingJSONDecodable {}
