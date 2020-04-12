//
//  Song+UseCases.swift
//  Eurovision2020
//
//  Created by Sacha DSO on 12/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import Foundation
import Combine

extension Song {
    
    enum Endpoint {
        static var fetchSongs: (() -> AnyPublisher<[Song], Error>)!
    }
    
    static func fetchSongs() -> AnyPublisher<[Song], Error> {
        Song.Endpoint.fetchSongs!()
    }
}

