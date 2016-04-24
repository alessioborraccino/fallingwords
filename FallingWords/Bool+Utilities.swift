//
//  Bool+Utilities.swift
//  FallingWords
//
//  Created by Alessio Borraccino on 17/01/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Foundation

extension Bool {

    static func random() -> Bool {
        let index = Int(arc4random_uniform(UInt32(2)))
        return index == 1
    }
}