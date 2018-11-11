//
//  RomanCovertor.swift
//  NYTimes
//
//  Created by Irfan Khatik on 11/11/18.
//  Copyright © 2018 NewYorkTimes. All rights reserved.
//

// UIKit import not required
import Foundation

class RomanNumber {
    // We can increase max value limit upto 4999
    // With below implementation
    private let MAX_VALUE = 3000 // 4999
    private let minValue = 0
    
    private var _number = 0
    private var number: Int {
        set(newValue) {
            if(MAX_VALUE < newValue) {
                _number = MAX_VALUE
            } else if(minValue > newValue){
                _number = minValue
            } else {
                _number = newValue
            }
        }
        
        get {
            return _number
        }
        
        /*
        // When a property is set in an initializer
        // willset and didset observers cannot be called.
        didSet {
            if(number > MAX_VALUE) {
                number = MAX_VALUE
            }
        }*/
    }
    
    init(value: Int) {
        // We are setting property in intializer
        self.number = value
    }
    
    func convert() -> String {
        var result = ""
        if minValue == number {
            print("Value must be greater than or equal to 1")
            return ""
        }
        
        let thousands = (number / 1000)
        result += times(thousands, character: "M")
        let hundreds = (number / 100) % 10
        result += times(hundreds, o: "C", f: "D", t: "M")
        let tens = (number / 10) % 10
        result += times(tens, o: "X", f: "L", t: "C")
        let ones = number % 10
        result += times(ones, o: "I", f: "V", t: "X")
        
        return result
    }
    
    private func times(_ value: Int, character: String) -> String {
        var result = ""
        // Add check for 0 or less than 0
        if 0 == value {
            return result
        }
        
        // Starts for loop from 1 instead of 0
        for _ in (1...value) {
            result += character
        }
        
        return result
    }
    
    private func times(_ value:Int, o: String, f: String, t: String) -> String {
        guard value < 10 else {
            // Replace "number" with "value"
            print("Only single digit allowed - not " + String(value))
            return ""
        }
        
        // Remove unwanted break statement
        switch value {
        case 0: return ""
        case 1, 2, 3: return times(value, character: o);
        case 4: return o + f
            // Replace "number" with "value"
        case 5, 6, 7, 8: return f + times(value - 5, character: o)
        case 9: return o + t
        default: break
        }
        return ""
    }
}
