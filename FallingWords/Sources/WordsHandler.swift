//
//  WordsHandler.swift
//  FallingWords
//
//  Created by Alessio Borraccino on 16/01/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol WordsHandlerType {
    func wordsWithLanguageOne(languageOne: WordLanguage, andLanguageTwo languageTwo: WordLanguage) -> [TranslatedWordType]
}

class WordsHandler : WordsHandlerType {

    let dataHandler : DataHandlerType

    init(dataHandler: DataHandlerType) {
        self.dataHandler = dataHandler
    }

    private func allAvailableWords() -> [TranslatedWordType] {
        do {
            let json = try dataHandler.jsonDataFromFileNamed("words")

            var words = [TranslatedWordType]()
            for (_,wordJson) in json {
                let word = Word(translationsJson: wordJson)
                words.append(word)
            }
            return words
        } catch {
            return []
        }
    }

    func wordsWithLanguageOne(languageOne: WordLanguage, andLanguageTwo languageTwo: WordLanguage) -> [TranslatedWordType] {
        let words : [TranslatedWordType] = allAvailableWords()
        return words.filter({ (word) -> Bool in
            if let _ = word[languageOne], let _ = word[languageTwo] {
                return true
            } else {
                return false
            }
        })
    }
}