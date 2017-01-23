//
//  Pegs.swift
//  MasterMind
//
//  Created by Jonathon Day on 1/19/17.
//  Copyright © 2017 dayj. All rights reserved.
//

import Foundation
import UIKit


enum CodePeg: Int {
    case blue = 0,
    brown = 1,
    green = 2,
    purple = 3,
    orange = 4,
    red = 5
    
    var color: UIColor {
        switch self {
        case .blue:
            return UIColor.blue
        case .brown:
            return UIColor.brown
        case .green:
            return UIColor.green
        case .purple:
            return UIColor.purple
        case .orange:
            return UIColor.orange
        case .red:
            return UIColor.red
        }
    }
    
    init(color: UIColor) {
        switch color {
        case UIColor.blue:
            self = .blue
        case UIColor.brown:
            self = .brown
        case UIColor.green:
            self = .green
        case UIColor.purple:
            self = .purple
        case UIColor.orange:
            self = .orange
        case UIColor.red:
            self = .red
        default:
            fatalError()
        }
    }
    
    static var allColors: [UIColor] {
        return [UIColor.blue, UIColor.brown, UIColor.green, UIColor.purple, UIColor.orange, UIColor.red]

    }
    
}


enum KeyPeg {
    case black,
    white
    
    var color: UIColor {
        switch self {
        case .black:
            return UIColor.black
        case .white:
            return UIColor.white
        }
    }
}
