//
//  MapMaybe.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 13/5/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation

func mapSome<S: Sequence, D: RangeReplaceableCollection>
    (_ source: S, transform: (S.Iterator.Element)->D.Iterator.Element?)
    -> D {
        var result = D()
        for x in source {
            if let y = transform(x) {
                result.append(y)
            }
        }
        return result
}

// version that defaults to returning an array if unspecified
func mapSome<S: Sequence, T>
    (_ source: S, transform: (S.Iterator.Element)->T?) -> [T] {
        return mapSome(source, transform: transform)
}
