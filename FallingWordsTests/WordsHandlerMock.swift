//
//  WordsHandlerMock.swift
//  FallingWords
//
//  Created by Alessio Borraccino on 24/04/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

@testable import FallingWords
import SwiftyJSON

class WordsHandlerMock : WordsHandlerType {
    func wordsWithLanguageOne(languageOne: WordLanguage, andLanguageTwo languageTwo: WordLanguage) -> [TranslatedWordType] {
        return translatedWords()
    }

    private func translatedWords() -> [TranslatedWordType] {
        return [
            Word(translationsJson: exampleJSONWord1()),
            Word(translationsJson: exampleJSONWord2())
        ]
    }

    private func exampleJSONWord1() -> JSON {
        return JSON(dictionaryLiteral:
            ("text_eng","hello"),
            ("text_spa","hola")
        )
    }
    private func exampleJSONWord2() -> JSON {
        return JSON(dictionaryLiteral:
            ("text_eng","small"),
            ("text_spa","pequeño")
        )
    }
}
