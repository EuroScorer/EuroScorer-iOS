//
//  Country+UseCases.swift
//  Eurovision2020
//
//  Created by Sacha DSO on 12/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import Foundation
import Combine

extension Country {
    
    enum Endpoint {
        static var fetchCountries: (() -> AnyPublisher<[Country], Error>)!
    }
    
    static func fetchCountries() -> AnyPublisher<[Country], Error> {
        Country.Endpoint.fetchCountries!()
    }
}
