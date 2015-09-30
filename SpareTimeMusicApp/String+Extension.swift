//
//  String+Extension.swift
//  SpareTimeAlarmApp
//
//  Created by Pham Nguyen Nhat Trung on 9/9/15.
//  Copyright (c) 2015 Pham Nguyen Nhat Trung. All rights reserved.
//

import Foundation

// Found this snippet on https://gist.github.com/albertbori/0faf7de867d96eb83591
extension String
{
    var length: Int {
        get {
            return characters.count
        }
    }
    
    func contains(s: String) -> Bool
    {
        return (rangeOfString(s) != nil) ? true : false
    }
    
    func containsAllStrings(sArray: String...) -> Bool
    {
        var result: Bool = Bool()
        for s in sArray {
            result = contains(s) && result
        }
        return result
    }
    
    func replace(target: String, withString: String) -> String
    {
        return stringByReplacingOccurrencesOfString(target, withString: withString, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    subscript (i: Int) -> Character
        {
        get {
            let index = startIndex.advancedBy(i)
            return self[index]
        }
    }
    
    subscript (r: Range<Int>) -> String
        {
        get {
            let startIndex = self.startIndex.advancedBy(r.startIndex)
            let endIndex = self.startIndex.advancedBy(r.endIndex - 1)
            
            return self[Range(start: startIndex, end: endIndex)]
        }
    }
    
    func subString(startIndex: Int, length: Int) -> String
    {
        let start = self.startIndex.advancedBy(startIndex)
        let end = self.startIndex.advancedBy(startIndex + length)
        return self.substringWithRange(Range<String.Index>(start: start, end: end))
    }
    
    func indexOf(target: String) -> Int
    {
        let range = rangeOfString(target)
        if let range = range {
            return startIndex.distanceTo(range.startIndex)
        } else {
            return -1
        }
    }
    
    func indexOf(target: String, startIndex: Int) -> Int
    {
        let startRange = self.startIndex.advancedBy(startIndex)
        
        let range = self.rangeOfString(target, options: NSStringCompareOptions.LiteralSearch, range: Range<String.Index>(start: startRange, end: self.endIndex))
        
        if let range = range {
            return self.startIndex.distanceTo(range.startIndex)
        } else {
            return -1
        }
    }
    
    func lastIndexOf(target: String) -> Int
    {
        var index = -1
        var stepIndex = indexOf(target)
        while stepIndex > -1
        {
            index = stepIndex
            if stepIndex + target.length < length {
                stepIndex = indexOf(target, startIndex: stepIndex + target.length)
            } else {
                stepIndex = -1
            }
        }
        return index
    }
    
    func isMatch(regex: String, options: NSRegularExpressionOptions) -> Bool
    {
        var error: NSError?
        var exp: NSRegularExpression?
        do {
            exp = try NSRegularExpression(pattern: regex, options: options)
        } catch let error1 as NSError {
            error = error1
            exp = nil
        }
        if let expression = exp {
            if let error = error {
                print(error.description)
            }
            let matchCount = expression.numberOfMatchesInString(self, options: [], range: NSMakeRange(0, length))
            return matchCount > 0
        } else {
            return false
        }
        
    }
    
    func getMatches(regex: String, options: NSRegularExpressionOptions) -> [NSTextCheckingResult]?
    {
        var exp: NSRegularExpression?
        do {
            exp = try NSRegularExpression(pattern: regex, options: options)
        } catch let error as NSError {
            exp = nil
            print(error.description)
            return nil
        }
        if let expression = exp {
            let matches = expression.matchesInString(self, options: [], range: NSMakeRange(0, length))
            return matches
        } else {
            return nil
        }
    }
    
}