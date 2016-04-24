//
//  ArraySampler.swift
//  FallingWords
//
//  Created by Alessio Borraccino on 21/04/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Foundation

protocol WordsSamplerType {
    func getTwoWordsFromWordArray(array: [TranslatedWordType]) -> (first: TranslatedWordType, second: TranslatedWordType)? 
}

class RandomWordsSampler : WordsSamplerType {

    func getTwoWordsFromWordArray(array: [TranslatedWordType]) -> (first: TranslatedWordType, second: TranslatedWordType)? {
        guard array.count >= 2 else {
            return nil
        }

        let randomIndex = array.getRandomIndexInBounds()!
        let firstRandomElement = array[randomIndex]
        let arrayWithoutFirstRandomElement = array.arrayByRemovingElementAtIndex(randomIndex)
        let secondRandomElement = arrayWithoutFirstRandomElement.getRandomElement()!
        return (first: firstRandomElement,second: secondRandomElement)
    }
}