//
//  FallingWordsTests.swift
//  FallingWordsTests
//
//  Created by Alessio Borraccino on 17/01/16.
//  Copyright © 2016 Alessio Borraccino. All rights reserved.
//

import XCTest
import RxSwift

@testable import FallingWords

class CountdownTests: XCTestCase {

    private let countdown : CountdownType = Countdown(totalTicks: 3, tickDuration: 0.01)
    private let disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        countdown.stop()
        super.tearDown()
    }
    
    func testRestart() {

        XCTAssertEqual(countdown.ticksLeft.value, 3)
        
        let expectation = expectationWithDescription("countdown starts")
        countdown.ticksLeft.asObservable().skip(2).single().subscribeNext { (ticksLeft) in
            expectation.fulfill()
        }.addDisposableTo(disposeBag)

        countdown.restart()
        waitForExpectationsWithTimeout(countdown.tickDuration * 2) { (error) in
            XCTAssertNil(error, "Timeout reached")
            XCTAssertEqual(self.countdown.ticksLeft.value, 2)
        }
    }

    func testStop() {
        XCTAssertEqual(countdown.ticksLeft.value, 3)

        let expectation = expectationWithDescription("countdown stops")
        countdown.ticksLeft.asObservable().skip(2).subscribeNext { [unowned self] (ticksLeft) in
            self.countdown.stop()
            expectation.fulfill()
        }.addDisposableTo(disposeBag)

        countdown.restart()

        waitForExpectationsWithTimeout(countdown.tickDuration * 2) { (error) in
            XCTAssertNil(error, "Timeout reached")
            XCTAssertEqual(self.countdown.ticksLeft.value, 2)
        }
    }
    
}
