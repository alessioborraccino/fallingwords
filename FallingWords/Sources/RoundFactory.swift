//
//  RoundFactory.swift
//  FallingWords
//
//  Created by Alessio Borraccino on 24/04/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

protocol RoundFactoryType {

    func newRoundWithWords(words: [TranslatedWordType], languageOne: WordLanguage, languageTwo: WordLanguage) -> RoundType?
}

class RoundFactory: RoundFactoryType {

    let boolGenerator : BoolGeneratorType
    let wordsSampler: WordsSamplerType

    init(wordsSampler: WordsSamplerType = RandomWordsSampler(), boolGenerator: BoolGeneratorType = RandomBoolGenerator()) {
        self.boolGenerator = boolGenerator
        self.wordsSampler = wordsSampler
    }

    func newRoundWithWords(words: [TranslatedWordType], languageOne: WordLanguage, languageTwo: WordLanguage) -> RoundType? {
        return Round(fromWords: words, forLanguageOne: languageOne, languageTwo: languageTwo, boolGenerator: boolGenerator, wordsSampler: wordsSampler)
    }
}
