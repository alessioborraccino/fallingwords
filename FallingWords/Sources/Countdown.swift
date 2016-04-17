//
//  Countdown.swift
//  FallingWords
//
//  Created by Alessio Borraccino on 16/01/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Foundation
import RxSwift

protocol CountdownType {
    var duration : Int { get }
    var secondsLeft : Variable<Int> { get }
    func restart()
    func stop()
}

class Countdown : CountdownType {

    let secondsLeft = Variable<Int>(0)
    let duration : Int

    private var timerDisposable : Disposable?

    init(duration: Int) {
        self.duration = duration
    }

    deinit {
        timerDisposable?.dispose()
    }
    
    private func start() {
        self.secondsLeft.value = duration
        let timer = Observable<Int>
            .interval(1, scheduler: ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Default))
            .takeWhile { (_) -> Bool in
            return self.secondsLeft.value > 0
        }

        timerDisposable = timer.subscribeNext { [unowned self] (_) -> Void in
            self.secondsLeft.value -= 1
        }
    }

    func restart() {
        stop()
        start()
    }
    
    func stop() {
        timerDisposable?.dispose()
    }
}