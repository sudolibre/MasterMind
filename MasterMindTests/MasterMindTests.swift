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
        let pegs = [
        [CodePeg.brown, CodePeg.blue, CodePeg.purple, CodePeg.red], // 2 color matches
        [CodePeg.blue, CodePeg.red, CodePeg.green, CodePeg.purple], // 2 perfect matches
        [CodePeg.purple, CodePeg.brown, CodePeg.green, CodePeg.blue], // 2 perfect 1 color
        [CodePeg.purple, CodePeg.orange, CodePeg.red, CodePeg.green], // 1 color
        [CodePeg.blue, CodePeg.brown, CodePeg.green, CodePeg.orange], // all perfect
        [CodePeg.brown, CodePeg.blue, CodePeg.orange, CodePeg.green] // all color
        ]
        
        let codes = pegs.map { Code(pegs:$0)}
        
        let key = Code(pegs: [CodePeg.blue, CodePeg.brown, CodePeg.green, CodePeg.orange])
        let board = Board(codes: codes, key: key)!
        let result = board.hints
        let expectedPegs: [[KeyPeg]] = [
            [KeyPeg.white, KeyPeg.white],
            [KeyPeg.black, KeyPeg.black],
            [KeyPeg.black, KeyPeg.black, KeyPeg.white],
            [KeyPeg.white, KeyPeg.white],
            [KeyPeg.black, KeyPeg.black, KeyPeg.black, KeyPeg.black],
            [KeyPeg.white, KeyPeg.white, KeyPeg.white, KeyPeg.white]
        ]
        let expected = expectedPegs.map {Hint(pegs: $0)}
        
        XCTAssertTrue(result == expected)

    }
    
}
