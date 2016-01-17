//
//  GameViewModelBinder.swift
//  FallingWords
//
//  Created by Alessio Borraccino on 16/01/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import RxSwift

protocol GameViewModelBinder {
    func scoreText() -> Observable<String>
    func countDownText() -> Observable<String>
    func didStartNewRoundEvent() -> Observable<Bool>
    func didFinishRoundEventDidWin() -> Observable<Bool>
    func gameOverEventWithScore() -> Observable<Int>
    func currentWordToGuess() -> Observable<String>
    func currentOption() -> Observable<String>
    func roundDuration() -> Int
}