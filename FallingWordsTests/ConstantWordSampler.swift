//
//  ConstantWordSampler.swift
//  FallingWords
//
//  Created by Alessio Borraccino on 24/04/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

@testable import FallingWords

class ConstantWordSampler : WordsSamplerType {
    func getTwoWordsFromWordArray(array: [TranslatedWordType]) -> (first: TranslatedWordType, second: TranslatedWordType)? {
        guard array.count >= 2 else {
            return nil
        }

        return (first: array[0], second: array[1])
    }
}
