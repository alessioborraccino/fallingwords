//
//  GamePresenter.swift
//  FallingWords
//
//  Created by Alessio Borraccino on 16/01/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import RxSwift

protocol GameViewModelType {
    func scoreText() -> Observable<String>
    func countDownText() -> Observable<String>
    func didStartNewRoundEvent() -> Observable<Bool>
    func didFinishRoundEventDidWin() -> Observable<Bool>
    func gameOverEventWithScore() -> Observable<Int>
    func currentWordToGuess() -> Observable<String>
    func currentOption() -> Observable<String>
    func roundDuration() -> Int
}

protocol GameViewInteractorType {
    func tappedStartButton()
    func tappedGameButtonWithInput(input: RoundInput)
}

class GamePresenter : GameViewModelType, GameViewInteractorType {

    private let game : protocol<GameWithRoundsType, HasCountdownType>

    init(languageOne: WordLanguage, languageTwo:WordLanguage, wordsHandler: WordsHandlerType = WordsHandler(dataHandler: DataHandler())) {
        self.game = Game(wordsHandler: wordsHandler, languageOne: languageOne, languageTwo: languageTwo)
    }

    // MARK: From Game To ViewController (ViewModel)

    func scoreText() -> Observable<String> {
        return game.countdown.secondsLeft.asObservable().map { (seconds) -> String in
            return "Time Left: " + String(seconds)
        }
    }

    func countDownText() -> Observable<String> {
        return game.score.asObservable().map { (score) -> String in
            return "Score: " + String(score)
        }
    }

    func didStartNewRoundEvent() -> Observable<Bool> {
        return game.currentRound.asObservable().filter({ (round) -> Bool in
            round != nil
        }).map({ (round) -> Bool in
            return true
        })
    }

    func didFinishRoundEventDidWin() -> Observable<Bool> {
        return game.didRoundEndWithResultObservable.asObservable().map({ (result) -> Bool in
            switch result {
            case .Won:
                return true
            case .Lost:
                return false
            }
        })
    }

    func gameOverEventWithScore() -> Observable<Int> {
        return game.didGameEndWithScoreObservable
    }
    
    func currentWordToGuess() -> Observable<String> {
        return game.currentRound.asObservable().filter({ (round) -> Bool in
            return round != nil
        }).map({ (round) -> String in
            return round!.stringToGuess
        })
    }

    func currentOption() -> Observable<String> {
        return game.currentRound.asObservable().filter({ (round) -> Bool in
            return round != nil
        }).map({ (round) -> String in
            return round!.optionStringGiven
        })
    }

    func roundDuration() -> Int {
        return game.countdown.duration
    }

    // MARK: From ViewController to Game (ViewInteractor)

    func tappedStartButton() {
        game.start()
    }

    func tappedGameButtonWithInput(input: RoundInput) {
        game.endRoundWithInput(input)
    }
}
