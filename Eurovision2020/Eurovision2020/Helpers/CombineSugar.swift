//
//  CombineSugar.swift
//  Eurovision2020
//
//  Created by Sacha DSO on 12/04/2020.
//  Copyright © 2020 MarsacProductions. All rights reserved.
//

import Foundation
import Combine

public extension Publisher {
    
    func launchOnce() {
        var cancellable: AnyCancellable?
        cancellable = sink(receiveCompletion: { _ in
            cancellable?.cancel()
            cancellable = nil
        }) { _ in
            cancellable?.cancel()
            cancellable = nil
        }
    }
    
    func sink() -> AnyCancellable  {
         sink(receiveCompletion: { _ in }) { _ in }
    }
    
    func sinkAndStore(in set: inout Set<AnyCancellable>)  {
        sink().store(in: &set)
    }
    
    func chain(block: @escaping (Output) -> Void) -> AnyPublisher<Output, Failure> {
        map { output -> Output in
            block(output)
            return output
        }.eraseToAnyPublisher()
    }

    func then<T>(_ block: @escaping (Output) -> T) -> AnyPublisher<T, Failure> {
        map(block).eraseToAnyPublisher()
    }
    
    func then<T>(_ block: @escaping (Output) -> AnyPublisher<T, Failure>) -> AnyPublisher<T, Failure> {
        flatMap { output -> AnyPublisher<T, Failure> in
            block(output)
        }.eraseToAnyPublisher()
    }
    
    func then<T>(_ publisher: AnyPublisher<T, Failure>) -> AnyPublisher<T, Failure> {
        flatMap { _ -> AnyPublisher<T, Failure> in
            publisher
        }.eraseToAnyPublisher()
    }
    
    func onError(_ block: @escaping (Failure) -> Void) -> AnyPublisher<Output, Failure> {
        mapError { error -> Failure in
            block(error)
            return error
        }
        .eraseToAnyPublisher()
    }
    
    func finally(_ block: @escaping () -> Void) -> AnyPublisher<Output, Failure> {
        map { o -> Output in
            block()
            return o
        }.mapError { e -> Failure in
            block()
            return e
        }.eraseToAnyPublisher()
    }
    
    func validate(with error: Failure,
                         _ assertionBlock:@escaping ((Output) -> Bool)) -> AnyPublisher<Output, Failure> {
        return flatMap { output -> AnyPublisher<Output, Failure> in
            if assertionBlock(output) {
                return Just(output).setFailureType(to: Failure.self).eraseToAnyPublisher()
            } else {
                return Fail(outputType: Output.self, failure: error).eraseToAnyPublisher()
            }
        }.eraseToAnyPublisher()
    }
    
    func validate(_ assertionBlock:@escaping ((Output) -> Bool)) -> AnyPublisher<Output, Error> {
        tryMap { output -> Output in
            if !assertionBlock(output) {
                throw CombineSugarError.validationFailed
            }
            return output
        }.eraseToAnyPublisher()
    }
}


public enum CombineSugarError: Error {
    case validationFailed
    case unwrappingFailed
}

public extension Publishers {

    static func unwrap<T>(_ param: T?) -> AnyPublisher<T, Error> {
        if let param = param {
            return Just(param)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(outputType: T.self, failure: CombineSugarError.unwrappingFailed).eraseToAnyPublisher()
        }
    }
}



public extension Publisher {
    func toBool() -> AnyPublisher<Bool, Self.Failure> {
        return self.map { _ -> Bool in true }
        .replaceError(with: false)
        .setFailureType(to: Self.Failure.self)
        .eraseToAnyPublisher()
    }
}


public extension Publisher {
    func toResult() -> AnyPublisher<Result<Output, Failure>, Never> {
        return self.map(Result.success)
            .catch { CurrentValueSubject(Result.failure($0)) }
            .eraseToAnyPublisher()
    }
}

public extension Publisher {
    func toVoid() -> AnyPublisher<Void, Failure> {
        return self.map { _ -> Void in
            
        }.eraseToAnyPublisher()
    }
}
