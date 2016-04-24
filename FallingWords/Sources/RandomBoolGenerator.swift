//
//  RandomBoolGenerator.swift
//  FallingWords
//
//  Created by Alessio Borraccino on 20/04/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Foundation

protocol BoolGeneratorType {
    func next() -> Bool
}

class RandomBoolGenerator : BoolGeneratorType {
    func next() -> Bool {
        return Bool.random()
    }
}