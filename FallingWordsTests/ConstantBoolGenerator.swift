//
//  ConstantBoolGenerator.swift
//  FallingWords
//
//  Created by Alessio Borraccino on 21/04/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

@testable import FallingWords

class ConstantBoolGenerator : BoolGeneratorType {

    private let value : Bool
    
    init(value: Bool) {
        self.value = value
    }
    func next() -> Bool {
        return value
    }
}