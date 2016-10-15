//
//  Dictionary+Flatten.swift
//  TSales
//
//  Created by Guillermo Gutiérrez on 30/10/15.
//  Copyright © 2015 TwinCoders. All rights reserved.
//

import Foundation

protocol OptionalEquivalent {
    associatedtype WrappedValueType
    func toOptional() -> WrappedValueType?
}

extension Optional: OptionalEquivalent {
    typealias WrappedValueType = Wrapped
    func toOptional() -> WrappedValueType? {
        return self
    }
}

extension Dictionary where Value: OptionalEquivalent {
    func flatten() -> Dictionary<Key, Value.WrappedValueType> {
        var result = Dictionary<Key, Value.WrappedValueType>()
        for (key, value) in self {
            guard let value = value.toOptional() else { continue }
            result[key] = value
        }
        return result
    }
}
