//
//  Vote+UseCases.swift
//  Eurovision2020
//
//  Created by Sacha DSO on 16/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import Foundation
import Combine

extension Vote {
    
    enum Endpoint {
        static var sendVotes: (([String]) -> AnyPublisher<Void, Error>)!
    }
    
    static func sendVotes(_ votes: [String]) -> AnyPublisher<Void, Error> {
        Vote.Endpoint.sendVotes!(votes)
    }
}
