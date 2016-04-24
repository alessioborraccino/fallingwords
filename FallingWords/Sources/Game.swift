//
//  Game.swift
//  FallingWords
//
//  Created by Alessio Borraccino on 16/01/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Foundation
import RxSwift

enum RoundResult {
    case Won
    case Lost
}

protocol GameType {
    var score : Variable<Int> { get }
    var didGameEndWithScoreObservable : Observable<Int> { get }
    func start()
}

protocol HasCountdownType {
    var countdown : CountdownType { get }
}

protocol HasRoundsType {
    var currentRound : Variable<RoundType?> { get }
    var didRoundEndWithResultObservable : Observable<RoundResult> { get }
    func endRoundWithInput(input: RoundInput)
    func nextRound() -> RoundType?
}

class Game : GameType, HasCountdownType, HasRoundsType {

    static let defaultRoundDuration = 5
    static let correctWordScore = 5

    private let words : [TranslatedWordType]
    private let languageOne : WordLanguage
    private let languageTwo : WordLanguage

    let score : Variable<Int>
    let countdown : CountdownType
    let currentRound : Variable<RoundType?>

    private let roundFactory : RoundFactoryType
    private let roundEndedSubject : PublishSubject<RoundResult>
    private let gameOverSubject : PublishSubject<Int>

    lazy private(set) var didRoundEndWithResultObservable : Observable<RoundResult> = {
        return self.roundEndedSubject.asObservable()
    }()
    lazy private(set) var didGameEndWithScoreObservable : Observable<Int> = {
        return self.gameOverSubject.asObservable()
    }()
    
    private let disposeBag = DisposeBag()
    
    init(languageOne: WordLanguage, languageTwo:WordLanguage,
         wordsHandler: WordsHandlerType,
         countDown: CountdownType = Countdown(totalTicks: Game.defaultRoundDuration),
         roundFactory: RoundFactoryType = RoundFactory()) {

        self.roundFactory = roundFactory
        self.gameOverSubject = PublishSubject<Int>()
        self.roundEndedSubject = PublishSubject<RoundResult>()

        self.languageOne = languageOne
        self.languageTwo = languageTwo
        self.countdown = countDown

        self.words = wordsHandler.wordsWithLanguageOne(languageOne, andLanguageTwo: languageTwo)
        self.score = Variable<Int>(0)
        self.currentRound = Variable<RoundType?>(nil)

        self.setRules()
    }

    func start() {
        self.score.value = 0
        self.startNewRound()
    }

    func endRoundWithInput(input: RoundInput) {
        let result = roundResultWithInput(input)
        self.updateScoreWithResult(result)
        self.roundEndedSubject.onNext(result)
    }

    func nextRound() -> RoundType? {
        return roundFactory.newRoundWithWords(words, languageOne: languageOne, languageTwo: languageTwo)
    }

    private func setRules() {
        self.bindStartNextRoundToObservable(roundEndedWithWonResultObservable())
        self.bindGameOverToObservable(countdownEndObservable())
        self.bindGameOverToObservable(roundEndedWithLostResultObservable())
    }

    private func bindGameOverToObservable(observable: Observable<Bool>) {
        observable.subscribeNext { [unowned self] (_) -> Void in
            self.gameOver()
        }.addDisposableTo(disposeBag)
    }

    private func bindStartNextRoundToObservable(observable: Observable<Bool>) {
        observable.subscribeNext { [unowned self] (_) -> Void in
            self.startNewRound()
        }.addDisposableTo(disposeBag)
    }

    private func startNewRound() {
        self.currentRound.value = nextRound()
        self.countdown.restart()
    }

    private func gameOver() {
        self.countdown.stop()
        self.gameOverSubject.onNext(score.value)
    }

    private func updateScoreWithResult(result: RoundResult) {
        switch result {
        case .Won:
            score.value += Game.correctWordScore
        case .Lost:
            break
        }
    }

    // MARK: Helpers

    private func countdownEndObservable() -> Observable<Bool> {
        return self.countdown.ticksLeft.asObservable().filter { seconds -> Bool in
            return seconds == 0
        }.map { (_) -> Bool in
            return true
        }
    }
    private func roundEndedWithLostResultObservable() -> Observable<Bool> {
        return self.didRoundEndWithResultObservable.filter { roundResult -> Bool in
            return roundResult == RoundResult.Lost
        }.map { (_) -> Bool in
            return true
        }
    }
    private func roundEndedWithWonResultObservable() -> Observable<Bool> {
        return self.didRoundEndWithResultObservable.asObservable().filter { roundResult -> Bool in
            return roundResult == .Won
        }.map { (_) -> Bool in
            return true
        }
    }

    private func roundResultWithInput(input: RoundInput) -> RoundResult {
        if input == self.currentRound.value?.expectedInput {
            return .Won
        } else {
            return .Lost
        }
    }
}