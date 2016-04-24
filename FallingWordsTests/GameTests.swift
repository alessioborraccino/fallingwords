//
//  GameTests.swift
//  FallingWords
//
//  Created by Alessio Borraccino on 24/04/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import XCTest
@testable import FallingWords
import RxSwift

class GameTests: XCTestCase {

    private var game: protocol<GameType,HasRoundsType,HasCountdownType>!
    private let disposeBag = DisposeBag()
    override func setUp() {
        super.setUp()

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testStartGameAndDoNothingUntilCountdownEnds() {

        self.game = Game(languageOne: .English, languageTwo: .Spanish,
                         wordsHandler: WordsHandlerMock(),
                         countDown: Countdown(totalTicks: 1, tickDuration: 0.01))

        XCTAssertEqual(game.score.value, 0)

        let expectation = expectationWithDescription("game will end with score 0")
        game.didGameEndWithScoreObservable.subscribeNext { (score) in
            expectation.fulfill()
        }.addDisposableTo(disposeBag)

        game.start()
        waitForExpectationsWithTimeout(0.01 * 2) { (error) in
            XCTAssertEqual(self.game.score.value, 0)
        }
    }

    func testStartGameAndEnterWrongInput() {
        self.game = Game(languageOne: .English, languageTwo: .Spanish,
                         wordsHandler: WordsHandlerMock(),
                         countDown: Countdown(totalTicks: 1, tickDuration: 0.01),
                         roundFactory: RoundFactory(wordsSampler: ConstantWordSampler(), boolGenerator: ConstantBoolGenerator(value: true)))
        XCTAssertEqual(game.score.value, 0)

        let expectation = expectationWithDescription("game will end with score 5")
        game.didGameEndWithScoreObservable.subscribeNext { (score) in
            expectation.fulfill()
        }.addDisposableTo(disposeBag)

        game.start()
        game.endRoundWithInput(.WrongButtonTapped)
        
        waitForExpectationsWithTimeout(0.01 * 2) { (error) in
            XCTAssertEqual(self.game.score.value, 0)
        }
    }

    func testStartGameAndEnterCorrectInputOnce() {

        self.game = Game(languageOne: .English, languageTwo: .Spanish,
                         wordsHandler: WordsHandlerMock(),
                         countDown: Countdown(totalTicks: 1, tickDuration: 0.01),
                         roundFactory: RoundFactory(wordsSampler: ConstantWordSampler(), boolGenerator: ConstantBoolGenerator(value: true)))
        XCTAssertEqual(game.score.value, 0)

        let expectation = expectationWithDescription("game will end with score 5")
        game.didGameEndWithScoreObservable.subscribeNext { (score) in
            expectation.fulfill()
        }.addDisposableTo(disposeBag)

        game.start()
        game.endRoundWithInput(.CorrectButtonTapped)

        waitForExpectationsWithTimeout(0.01 * 2) { (error) in
            XCTAssertEqual(self.game.score.value, Game.correctWordScore)
        }
    }

    func testStartGameAndEnterCorrectInputTwice() {

        self.game = Game(languageOne: .English, languageTwo: .Spanish,
                         wordsHandler: WordsHandlerMock(),
                         countDown: Countdown(totalTicks: 1, tickDuration: 0.01),
                         roundFactory: RoundFactory(wordsSampler: ConstantWordSampler(), boolGenerator: ConstantBoolGenerator(value: true)))
        XCTAssertEqual(game.score.value, 0)

        let expectation = expectationWithDescription("game will end with score 5")
        game.didGameEndWithScoreObservable.subscribeNext { (score) in
            expectation.fulfill()
        }.addDisposableTo(disposeBag)

        game.start()
        game.endRoundWithInput(.CorrectButtonTapped)
        game.endRoundWithInput(.CorrectButtonTapped)

        waitForExpectationsWithTimeout(0.01 * 2) { (error) in
            XCTAssertEqual(self.game.score.value, Game.correctWordScore * 2)
        }
    }
}
