//
//  String+Localizable.swift
//  Wuakup
//
//  Created by Guillermo Gutiérrez on 26/01/15.
//  Copyright (c) 2015 Yellow Pineapple. All rights reserved.
//

import Foundation

extension String {
    func i18n() -> String {
        return NSLocalizedString(self, comment: "")
    }
}