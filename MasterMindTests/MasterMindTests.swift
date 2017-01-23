//
//  MasterMindTests.swift
//  MasterMindTests
//
//  Created by Jonathon Day on 1/19/17.
//  Copyright © 2017 dayj. All rights reserved.
//

import XCTest
@testable import MasterMind

class MasterMindTests: XCTestCase {
  
    func testBoardKeyHints() {
        let codes = [
        [CodePeg.brown, CodePeg.blue, CodePeg.purple, CodePeg.red], // 2 color matches
        [CodePeg.blue, CodePeg.red, CodePeg.green, CodePeg.purple], // 2 perfect matches
        [CodePeg.purple, CodePeg.brown, CodePeg.green, CodePeg.blue], // 2 perfect 1 color
        [CodePeg.purple, CodePeg.orange, CodePeg.red, CodePeg.green], // 1 color
        [CodePeg.blue, CodePeg.brown, CodePeg.green, CodePeg.orange], // all perfect
        [CodePeg.brown, CodePeg.blue, CodePeg.orange, CodePeg.green] // all color
        ]
        
        let key = [CodePeg.blue, CodePeg.brown, CodePeg.green, CodePeg.orange]
        let board = Board(slots: codes, key: key)!
        let result = board.keyHintSlots
        let expected: [[KeyPeg?]] = [
            [KeyPeg.white, KeyPeg.white, nil, nil],
            [KeyPeg.black, KeyPeg.black, nil, nil],
            [KeyPeg.black, KeyPeg.black, KeyPeg.white, nil],
            [KeyPeg.white, KeyPeg.white, nil, nil],
            [KeyPeg.black, KeyPeg.black, KeyPeg.black, KeyPeg.black],
            [KeyPeg.white, KeyPeg.white, KeyPeg.white, KeyPeg.white]
        ]
        
        for r in 0..<6 {
            for p in 0..<4 {
                print(result[r][p].debugDescription)
                print(" == ")
                print(expected[r][p].debugDescription)
                    print("----------")
            XCTAssertTrue(result[r][p] == expected[r][p])
            }
        }

    }
    
}
