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
    var totalTicks : Int { get }
    var tickDuration : Double { get }
    var ticksLeft : Variable<Int> { get }
    func restart()
    func stop()
}

class Countdown : CountdownType {

    let totalTicks : Int
    let tickDuration : Double
    let ticksLeft : Variable<Int>

    private var timerDisposable : Disposable?

    init(totalTicks: Int, tickDuration: Double = 1) {
        self.totalTicks = totalTicks
        self.ticksLeft = Variable<Int>(totalTicks)
        self.tickDuration = tickDuration
    }

    deinit {
        timerDisposable?.dispose()
    }
    
    private func start() {
        self.ticksLeft.value = totalTicks
        let timer = Observable<Int>
            .interval(tickDuration, scheduler: ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Default))
            .takeWhile { (_) -> Bool in
            return self.ticksLeft.value > 0
        }

        timerDisposable = timer.subscribeNext { [unowned self] (_) -> Void in
            self.ticksLeft.value -= 1
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