//
//  WordsHandler.swift
//  FallingWords
//
//  Created by Alessio Borraccino on 16/01/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Foundation
import SwiftyJSON

class WordsHandler {

    private class func allAvailableWords() -> [Word] {
        do {
            let json = try DataHandler.jsonDataFromFileNamed("words")

            var words = [Word]()
            for (_,wordJson) in json {
                let word = Word(translationsJson: wordJson)
                words.append(word)
            }
            return words
        } catch {
            return []
        }
    }

    class func wordsWithLanguageOne(languageOne: WordLanguage, andLanguageTwo languageTwo: WordLanguage) -> [Word] {
        let words = WordsHandler.allAvailableWords()
        return words.filter({ (word) -> Bool in
            if let _ = word[languageOne], let _ = word[languageTwo] {
                return true
            } else {
                return false
            }
        })
    }
}