//
//  Code.swift
//  MasterMind
//
//  Created by Jonathon Day on 1/22/17.
//  Copyright © 2017 dayj. All rights reserved.
//

import Foundation

struct Code: Equatable {
    var pegs: [CodePeg]
    
    static func ==(_ lhs: Code, _ rhs: Code) -> Bool {
        return lhs.pegs == rhs.pegs
    }
}
