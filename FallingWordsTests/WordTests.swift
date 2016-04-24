//
//  WordTests.swift
//  FallingWords
//
//  Created by Alessio Borraccino on 20/04/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import XCTest
import SwiftyJSON

@testable import FallingWords

class WordTests: XCTestCase {

    private lazy var word : TranslatedWordType = Word(translationsJson: self.exampleJSONWord())

    func testSubscript() {
        XCTAssertEqual(word[.English], "hello")
        XCTAssertEqual(word[.Spanish], "hola")
    }

    private func exampleJSONWord() -> JSON {
        return JSON(dictionaryLiteral:
            ("text_eng","hello"),
            ("text_spa","hola")
        )
    }
}
