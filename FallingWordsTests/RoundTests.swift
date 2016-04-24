//
//  RoundTests.swift
//  FallingWords
//
//  Created by Alessio Borraccino on 20/04/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import XCTest
import SwiftyJSON

@testable import FallingWords

class RoundTests: XCTestCase {

    private var wordsHandlerMock: WordsHandlerType!
    private var round : RoundType!

    override func setUp() {
        super.setUp()
        self.wordsHandlerMock = WordsHandlerMock()
        let words = self.wordsHandlerMock.wordsWithLanguageOne(.English, andLanguageTwo: .Spanish)
        self.round = Round(fromWords: words, forLanguageOne: .English, languageTwo: .Spanish,
                           wordsSampler: ConstantWordSampler(),
                           boolGenerator: ConstantBoolGenerator(value: true))
    }

    func testCorrectAssignmentToRoundProperties() {

        XCTAssertEqual(round.stringToGuess, "hello")
        XCTAssertEqual(round.optionStringGiven, "hola")
        XCTAssertEqual(round.expectedInput, RoundInput.CorrectButtonTapped)
    }
}
