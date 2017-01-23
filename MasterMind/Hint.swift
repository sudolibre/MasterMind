//
//  hints.swift
//  MasterMind
//
//  Created by Jonathon Day on 1/22/17.
//  Copyright © 2017 dayj. All rights reserved.
//

import Foundation

struct Hint: Equatable {
    var pegs: [KeyPeg]
    
    static func ==(_ lhs: Hint, _ rhs: Hint) -> Bool {
        return lhs.pegs == rhs.pegs
    }

}
