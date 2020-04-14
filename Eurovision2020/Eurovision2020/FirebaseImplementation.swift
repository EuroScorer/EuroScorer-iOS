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

struct FirebaseImplementation: NetworkingService {
    
    var network = NetworkingClient(baseURL: "https://us-central1-eurovision2020-ea486.cloudfunctions.net/api/v1")
    
    func fetchSongs() -> AnyPublisher<[Song], Error> {
        get("/songs")
    }
}

extension Song: NetworkingJSONDecodable {}
