//
//  NYTimesTests.swift
//  NYTimesTests
//
//  Created by Irfan Khatik on 11/11/18.
//  Copyright © 2018 NewYorkTimes. All rights reserved.
//

import XCTest
@testable import NYTimes

class NYTimesTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRomanConvertorForNegativeValue() {
        let number = RomanNumber(value: -200)
        let str = number.convert()
        XCTAssertEqual("", str)
    }
    
    func testRomanConvertorForZeroValue() {
        let number = RomanNumber(value: 0)
        let str = number.convert()
        XCTAssertEqual("", str)
    }
    
    func testRomanConvertorForSingleDigitValue() {
        let number = RomanNumber(value: 1)
        let str = number.convert()
        XCTAssertEqual("I", str)
    }
    
    func testRomanConvertorForTwoDigitValue() {
        let number = RomanNumber(value: 15)
        let str = number.convert()
        XCTAssertEqual("XV", str)
    }
    
    func testRomanConvertorForThreeDigitValue() {
        let number = RomanNumber(value: 159)
        let str = number.convert()
        XCTAssertEqual("CLIX", str)
    }
    
    func testRomanConvertorForFourDigitValue() {
        let number = RomanNumber(value: 1539)
        let str = number.convert()
        XCTAssertEqual("MDXXXIX", str)
    }

    func testRomanConvertorForBoundaryValue() {
        let number = RomanNumber(value: 3000)
        let str = number.convert()
        XCTAssertEqual("MMM", str)
    }
    
    func testRomanConvertorForExceededMaxBoundaryValue() {
        let number = RomanNumber(value: 5000)
        let str = number.convert()
        XCTAssertEqual("MMM", str)
    }
    
    func testRomanConverterPerformance() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            let number = RomanNumber(value: 5000)
            _ = number.convert()
        }
    }

    
}
