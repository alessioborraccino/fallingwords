//
//  GamePresenterTests.swift
//  FallingWords
//
//  Created by Alessio Borraccino on 24/04/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import XCTest
@testable import FallingWords
import RxSwift

class GamePresenterTests: XCTestCase {

    private var gamePresenter: protocol<GameViewModelType, GameViewInteractorType>!
    private let disposeBag = DisposeBag()

    override func setUp() {
        super.setUp()
        gamePresenter = GamePresenter(languageOne: .English, languageTwo: .Spanish,
                                      wordsHandler: WordsHandlerMock(),
                                      countDown: Countdown(totalTicks: 5, tickDuration: 0.01),
                                      roundFactory: RoundFactory(wordsSampler: ConstantWordSampler(), boolGenerator: ConstantBoolGenerator(value: true)))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testScoreTextAfterStart() {
        var scoreStringAfterStart = String()

        let startExpectation = expectationWithDescription("correct score string at the Start")
        gamePresenter.scoreText().skip(1).single().subscribeNext { (scoreString) in
            scoreStringAfterStart = scoreString
            startExpectation.fulfill()
        }.addDisposableTo(disposeBag)
        gamePresenter.tappedStartButton()

        waitForExpectationsWithTimeout(0.02) { (error) in
            XCTAssertEqual(scoreStringAfterStart, "Score: 0")
        }
    }

    func testScoreTextAfterWinningRound() {
        var scoreStringAfterWinningRound = String()

        let expectation = expectationWithDescription("correct score string at the Start")
        gamePresenter.scoreText().skip(2).single().subscribeNext { (scoreString) in
            scoreStringAfterWinningRound = scoreString
            expectation.fulfill()
            }.addDisposableTo(disposeBag)

        gamePresenter.tappedStartButton()
        gamePresenter.tappedGameButtonWithInput(.CorrectButtonTapped)

        waitForExpectationsWithTimeout(0.02) { (error) in
            XCTAssertEqual(scoreStringAfterWinningRound, "Score: 5")
        }
    }

    func testCoundownTextAfterStart() {
        var countdownStringAfterStart = String()
        let startExpectation = expectationWithDescription("correct score string at the Start")
        gamePresenter.countDownText().skip(1).single().subscribeNext { (countDownString) in
            countdownStringAfterStart = countDownString
            startExpectation.fulfill()
        }.addDisposableTo(disposeBag)

        gamePresenter.tappedStartButton()

        waitForExpectationsWithTimeout(0.02) { (error) in
            XCTAssertEqual(countdownStringAfterStart, "Time Left: 5")
        }
    }
    
    func testCoundownTextAfterTick() {
        var countdownStringAfterStart = String()
        let startExpectation = expectationWithDescription("correct score string at the Start")
        gamePresenter.countDownText().skip(2).single().subscribeNext { (countDownString) in
            countdownStringAfterStart = countDownString
            startExpectation.fulfill()
            }.addDisposableTo(disposeBag)

        gamePresenter.tappedStartButton()

        waitForExpectationsWithTimeout(0.02) { (error) in
            XCTAssertEqual(countdownStringAfterStart, "Time Left: 4")
        }
    }

    func testCoundownTextAfterWinningRound() {
        var countdownStringAfterStart = String()
        let startExpectation = expectationWithDescription("correct score string at the Start")
        gamePresenter.countDownText().skip(2).single().subscribeNext { (countDownString) in
            countdownStringAfterStart = countDownString
            startExpectation.fulfill()
        }.addDisposableTo(disposeBag)

        gamePresenter.tappedStartButton()
        gamePresenter.tappedGameButtonWithInput(.CorrectButtonTapped)

        waitForExpectationsWithTimeout(0.02) { (error) in
            XCTAssertEqual(countdownStringAfterStart, "Time Left: 5")
        }
    }

    func testDidStartNewRoundEventSentAtStart() {
        let expectation = expectationWithDescription("did start new round event sent")
        gamePresenter.didStartNewRoundEvent().single().subscribeNext { (_) in
            expectation.fulfill()
        }.addDisposableTo(disposeBag)
        gamePresenter.tappedStartButton()
        waitForExpectationsWithTimeout(0.02, handler: nil)
    }

    func testDidStartNewRoundEventSentAfterWinningRound() {
        let expectation = expectationWithDescription("did start new round event sent")
        gamePresenter.didStartNewRoundEvent().skip(1).single().subscribeNext { (_) in
            expectation.fulfill()
            }.addDisposableTo(disposeBag)
        gamePresenter.tappedStartButton()
        gamePresenter.tappedGameButtonWithInput(.CorrectButtonTapped)
        waitForExpectationsWithTimeout(0.02, handler: nil)
    }

    func testDidFinishRoundEventSentDidWinAfterWinningRound() {

        var roundDidWin = false
        let expectation = expectationWithDescription("did finish round event sent did win")
        gamePresenter.didFinishRoundEventDidWin().single().subscribeNext { (didWin) in
            roundDidWin = didWin
            expectation.fulfill()
        }.addDisposableTo(disposeBag)
        gamePresenter.tappedStartButton()
        gamePresenter.tappedGameButtonWithInput(.CorrectButtonTapped)
        waitForExpectationsWithTimeout(0.02, handler: { error in
            XCTAssertTrue(roundDidWin)
        })
    }

    func testDidFinishRoundEventSentDidNotWinAfterLosingRound() {

        var roundDidWin = false
        let expectation = expectationWithDescription("did finish round event sent did lose")
        gamePresenter.didFinishRoundEventDidWin().single().subscribeNext { (didWin) in
            roundDidWin = didWin
            expectation.fulfill()
            }.addDisposableTo(disposeBag)
        gamePresenter.tappedStartButton()
        gamePresenter.tappedGameButtonWithInput(.WrongButtonTapped)
        waitForExpectationsWithTimeout(0.02, handler: { error in
            XCTAssertFalse(roundDidWin)
        })
    }

    func testGameOverEventWithScoreSent() {
        let expectation = expectationWithDescription("did game over event sent")
        gamePresenter.gameOverEventWithScore().single().subscribeNext { (_) in
            expectation.fulfill()
        }.addDisposableTo(disposeBag)
        gamePresenter.tappedStartButton()
        waitForExpectationsWithTimeout(0.06, handler: nil)
    }

    func testRoundDuration() {
        XCTAssertEqual(gamePresenter.roundDuration(), 5)
    }
    func testCurrentOption() {
        var currentOption = String()
        let expectation = expectationWithDescription("current option is right")
        gamePresenter.currentOption().single().subscribeNext { (option) in
            currentOption = option
            expectation.fulfill()
        }.addDisposableTo(disposeBag)
        gamePresenter.tappedStartButton()
        waitForExpectationsWithTimeout(0.02) { (error) in
            XCTAssertEqual(currentOption, "hola")
        }
    }
    func testWordToGuess() {
        var currentWordToGuess = String()
        let expectation = expectationWithDescription("current word to guess is right")
        gamePresenter.currentWordToGuess().single().subscribeNext { (word) in
            currentWordToGuess = word
            expectation.fulfill()
            }.addDisposableTo(disposeBag)
        gamePresenter.tappedStartButton()
        waitForExpectationsWithTimeout(0.02) { (error) in
            XCTAssertEqual(currentWordToGuess, "hello")
        }
    }
}
