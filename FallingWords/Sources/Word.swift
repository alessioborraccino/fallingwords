//
//  Word.swift
//  FallingWords
//
//  Created by Alessio Borraccino on 16/01/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Foundation
import SwiftyJSON

enum WordLanguage : String {
    case English = "text_eng"
    case Spanish = "text_spa"
}

class Word {
    private let translations : [WordLanguage : String]

    subscript(language: WordLanguage) -> String? {
        return translations[language]
    }

    init(translations: [WordLanguage : String]) {
        self.translations = translations
    }

    convenience init(translationsJson: JSON) {
        var translations : [WordLanguage : String] = [WordLanguage : String]()
        for (language,translation):(String, JSON) in translationsJson {
            if let wordLanguage = WordLanguage(rawValue: language) {
                translations[wordLanguage] = translation.string
            }
        }
        self.init(translations: translations)
    }
}


