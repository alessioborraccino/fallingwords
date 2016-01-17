//
//  Countdown.swift
//  FallingWords
//
//  Created by Alessio Borraccino on 16/01/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import Foundation
import RxSwift

class Countdown {

    let seconds = Variable<Int>(0)
    let duration : Int

    private var timerDisposable : Disposable?

    init(duration: Int) {
        self.duration = duration
    }

    deinit {
        timerDisposable?.dispose()
    }
    
    private func start() {
        self.seconds.value = duration
        let timer = Observable<Int>
            .interval(1, scheduler: ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Default))
            .takeWhile { (_) -> Bool in
            return self.seconds.value > 0
        }

        timerDisposable = timer.subscribeNext { (_) -> Void in
            self.seconds.value--
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