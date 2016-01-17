//
//  Game.swift
//  FallingWords
//
//  Created by Alessio Borraccino on 16/01/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Foundation
import RxSwift

private let DefaultRoundDuration = 5
private let CorrectWordScore = 5

enum RoundResult {
    case Won
    case Lost
}

class Game {

    private let words : [Word]
    private let languageOne : WordLanguage
    private let languageTwo : WordLanguage
    
    let score : Variable<Int>
    let countdown : Countdown
    private(set) var currentRound : Variable<Round?>

    let roundEndedSubject : PublishSubject<RoundResult>
    let gameOverSubject : PublishSubject<Int>
    
    private let disposeBag = DisposeBag()
    
    init(languageOne: WordLanguage, languageTwo:WordLanguage, roundDuration:Int = DefaultRoundDuration) {

        self.gameOverSubject = PublishSubject<Int>()
        self.roundEndedSubject = PublishSubject<RoundResult>()

        self.languageOne = languageOne
        self.languageTwo = languageTwo
        self.countdown = Countdown(duration: roundDuration)
        self.words = WordsHandler.wordsWithLanguageOne(languageOne, andLanguageTwo: languageTwo)
        self.score = Variable<Int>(0)
        self.currentRound = Variable<Round?>(nil)

        self.setRules()
    }

    func setRules() {
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

    func start() {
        self.score.value = 0
        self.startNewRound()
    }

    func endRoundWithInput(input: RoundInput) {
        let result = roundResultWithInput(input)
        self.updateScoreWithResult(result)
        self.roundEndedSubject.onNext(result)
    }

    private func startNewRound() {
        let newRound = Round(randomFromWords: words, forLanguageOne: languageOne, andLanguageTwo: languageTwo)
        self.currentRound.value = newRound
        self.countdown.restart()
    }

    private func gameOver() {
        self.countdown.stop()
        self.gameOverSubject.onNext(score.value)
    }

    private func updateScoreWithResult(result: RoundResult) {
        switch result {
        case .Won:
            score.value += CorrectWordScore
        case .Lost:
            break
        }
    }

    // MARK: Helpers

    private func countdownEndObservable() -> Observable<Bool> {
        return self.countdown.seconds.asObservable().filter({ (seconds) -> Bool in
            return seconds == 0
        }).map({ (_) -> Bool in
            return true
        })
    }
    private func roundEndedWithLostResultObservable() -> Observable<Bool> {
        return self.roundEndedSubject.asObservable().filter({ (roundResult) -> Bool in
            return roundResult == .Lost
        }).map({ (_) -> Bool in
            return true
        })
    }
    private func roundEndedWithWonResultObservable() -> Observable<Bool> {
        return self.roundEndedSubject.asObservable().filter({ (roundResult) -> Bool in
            return roundResult == .Won
        }).map({ (_) -> Bool in
            return true
        })
    }

    private func roundResultWithInput(input: RoundInput) -> RoundResult{
        if input == self.currentRound.value?.expectedInput {
            return .Won
        } else {
            return .Lost
        }
    }
}