//
//  Round.swift
//  FallingWords
//
//  Created by Alessio Borraccino on 16/01/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Foundation

enum RoundInput {
    case CorrectButtonTapped
    case WrongButtonTapped
}

protocol RoundType {
    var stringToGuess : String { get }
    var optionStringGiven : String { get }
    var expectedInput : RoundInput { get }
}

class Round : RoundType {

    let stringToGuess: String
    let optionStringGiven: String
    let expectedInput: RoundInput

    private init(stringToGuess: String, optionStringGiven: String, expectedInput: RoundInput) {
        self.stringToGuess = stringToGuess
        self.optionStringGiven = optionStringGiven
        self.expectedInput = expectedInput
    }

    convenience init?(fromWords words: [TranslatedWordType], forLanguageOne languageOne: WordLanguage, languageTwo: WordLanguage,
                                boolGenerator: BoolGeneratorType = RandomBoolGenerator(),
                                wordsSampler: WordsSamplerType = RandomWordsSampler()) {

      if let wordTuple = wordsSampler.getTwoWordsFromWordArray(words) {
            if let stringToGuess = wordTuple.first[languageOne], correctOption = wordTuple.first[languageTwo], wrongOption = wordTuple.second[languageTwo] {
                let willGiveCorrectOption = boolGenerator.next()
                let option : String = willGiveCorrectOption ? correctOption : wrongOption
                let input : RoundInput = willGiveCorrectOption ? .CorrectButtonTapped : .WrongButtonTapped
                self.init(stringToGuess: stringToGuess, optionStringGiven: option, expectedInput: input)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}