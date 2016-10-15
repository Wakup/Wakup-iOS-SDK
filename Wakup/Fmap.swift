//
//  Fmap.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 02/02/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation

// Implementation of 'fmap' and 'apply' functions in swift for optional chaining handling
// More info: http://robots.thoughtbot.com/functional-swift-for-dealing-with-optional-values


infix operator <^> { associativity left }

// Fmap: Applies function conditionaly if the element is not None, returns None otherwise
func <^><A, B>(f: (A) -> B, a: A?) -> B? {
    switch a {
    case .some(let x): return f(x)
    case .none: return .none
    }
}


infix operator <*> { associativity left }

// Apply: Applies an optional function conditionally if both the element and the function are not None, returns None otherwise
func <*><A, B>(f: ((A) -> B)?, a: A?) -> B? {
    switch f {
    case .some(let fx): return fx <^> a
    case .none: return .none
    }
}
