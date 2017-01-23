//
//  Board.swift
//  MasterMind
//
//  Created by Jonathon Day on 1/19/17.
//  Copyright © 2017 dayj. All rights reserved.
//

import Foundation

class Board {
    var codes: [Code]
    var hints = [Hint]()
    var key: Code
    
    internal func addCode(_ code: Code) {
        codes.append(code)
        let hint = createHintFromKey(key: key, code: code)
        hints.append(hint)
    }
    
    private func createHintFromKey(key: Code, code: Code) -> Hint {
        var pegs = [KeyPeg]()
        
        let exactMatches = zip(key.pegs,code.pegs).reduce(0) { (count, pair) in
            if pair.0 == pair.1 {
                return count + 1
            } else {
                return count
            }
        }
        
        for _ in 0..<exactMatches {
            let blackPeg = KeyPeg.black
            pegs.append(blackPeg)
        }
        
        let colorMatches = Set(key.pegs).intersection(Set(code.pegs)).count
        
        for _ in 0..<(colorMatches - exactMatches) {
            let whitePeg = KeyPeg.white
            pegs.append(whitePeg)
        }
        
        return Hint(pegs: pegs)
    }
    
    
    init?(codes optionalCodes: [Code]?, key optionalKey: Code?) {
        let codeLength = 4
        let tryCount = 6
        
        if let codes = optionalCodes,
            let key = optionalKey {
            //if we have an unexpected count of slots or key length we fail initialization
            guard codes.count == tryCount,
                codes.flatMap({$0.pegs}).count == (codeLength * tryCount),
                key.pegs.count == codeLength,
                key.pegs.count == codeLength else {
                    return nil
            }
            self.codes = codes
            self.key = key
            
            var hints = [Hint]()
            for code in codes {
                hints.append(createHintFromKey(key: key, code: code))
            }

            self.hints = hints
            
        } else {
            // if we got nil for either slots or key we just create a new empty board
            self.codes = [Code]()
            self.key = {
                var colors = CodePeg.allColors
                var pegs = [CodePeg]()
                
                for _ in 0..<codeLength {
                    let randomInt = Int(arc4random_uniform(UInt32(colors.count)))
                    let color = colors[randomInt]
                    let code = CodePeg(color: color)
                    pegs.append(code)
                    colors.remove(at: randomInt)
                }
    
                return Code(pegs: pegs)
            }()
        }
    }
}

